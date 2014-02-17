class FileController < ApplicationController
require 'rubygems'
respond_to :html, :js

  def download
	input_id = params[:files].split
	access = if session[:user_id] then User.access(session[:user_id])+1 else -1 end
	documents = Document.where(:id_document => input_id)
	input_filenames = Array.new
	documents.each do |document|
		unless access < document.security
			input_filenames.push(document.path_file)
		end
	end

	if input_filenames.size > 0
		directory = 'C:/Upload/'+params[:fold]+'/'
		zip_directory = 'C:/Stor_download/'
		modif =  Time.now().strftime('%Y%m%d%H%M%S')
		zipfile_name = zip_directory + "doc#{modif}.zip"
		
		Zip::ZipFile.open(zipfile_name, Zip::ZipFile::CREATE) do |zipfile|
			i = 0
			input_filenames.each do |filename|
				name = filename.encode('cp866')
				zipfile.add(name, directory + filename)
				i = i+1
			end
		end
		
		zipfile = "doc#{modif}.zip"
		send_file(zipfile_name,
				#directory + input_filenames[0],
				:filename => zipfile,
				:x_sendfile => true)
	end
  end

  def show
	access = if session[:user_id] then User.access(session[:user_id])+1 else -1 end
	document = Document.find(params[:id])
	unless access < document.security
		directory = "C:/Upload/"+params[:fold]+"/"
		send_file(directory+document.path_file,
				:disposition => "inline")
	end
  end

end
