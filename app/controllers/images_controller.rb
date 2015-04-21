class ImagesController < ApplicationController
  respond_to :json

  skip_before_filter :authenticate_user_from_token!, only: [:shortcode, :create]

  def index
    @all =  Image.medium.unseen_by(current_user).super_hot.limit(180).to_a
    @all << Image.medium.unseen_by(current_user).least_seen.limit(90).to_a
    @all << Image.medium.unseen_by(current_user).rising.limit(90).to_a
    @all = @all.flatten.uniq.shuffle

    respond_with Kaminari.paginate_array(@all).page(params[:page])
  end

  def favorites
    respond_with Image.faved_by(current_user).page(params[:page]).per(50)
  end

  def shortcode
    headers['Access-Control-Allow-Origin'] = '*'
    image = Image.where(shortcode: params[:shortcode]).first
    if image
      respond_with image, status: :ok, root: false
    else
      respond_with Hash.new, status: :not_found
    end
  end

  # Paperclip handles only multipart/form-data requests. In order to make it easier for front-end or mobile
  # apps to upload files, we enable simple JSON requests to send the image file as a Base64 encoded string.
  def create
    # allow cors
    headers['Access-Control-Allow-Origin'] = '*'

    if image_params[:file].nil?
      if shortcode = image_params.fetch(:shortcode, nil)
        @image = Image.where(shortcode: shortcode).first_or_create
        @image.assign_attributes(image_params)
      else
        @image = Image.new(image_params)
      end
    else
      handle_uploaded_file
    end

    if @image.save
      FetchImageFromUrl.perform_async(image_params[:original_source], @image.id)
      render json: @image, status: :created
    else
      render json: { errors: @image.errors }, status: :unprocessable_entity
    end
  rescue Exception => e
    render json: { errors: e.message }, status: :unprocessable_entity
  end

  private

  def image_params
    params.require(:image).permit(:name, :original_source, :bytes, :shortcode, :file => [:filename, :content, :content_type])
  end

  def handle_uploaded_file
    uploaded_file = parse_image_data(image_params[:file])

    assign_params = image_params.dup
    assign_params[:bytes] = uploaded_file.try(:size)
    assign_params.delete(:file)

    @image = Image.new(assign_params)
    @image.file = uploaded_file
  ensure
    clean_tempfile
  end

  def parse_image_data(image_data)
    if image_data
      @tempfile = Tempfile.new('image')
      @tempfile.binmode
      @tempfile.write Base64.decode64(image_data[:content])
      @tempfile.rewind

      uploaded_file = ActionDispatch::Http::UploadedFile.new(
        tempfile: @tempfile,
        filename: image_data[:filename]
      )

      uploaded_file.content_type = image_data[:content_type]
      uploaded_file
    end
  end

  def clean_tempfile
    if @tempfile
      @tempfile.close
      @tempfile.unlink
    end
  end
end
