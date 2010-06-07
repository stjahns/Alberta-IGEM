class UploadController < ApplicationController
	def index
	  render :file => 'app\views\upload\uploadfile.html.erb'
	end
	def uploadImage
		post = DataFile.save(params[:upload])
		render :text => "File has been uploaded successfully"
	end
end
