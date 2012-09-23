class EmailsController < ApplicationController
	def index
		lim = params[:limit]
		off = params[:offset]
		lim ||= 50
		off ||= 0
		@body_regex = /<body [\w\d="'#\s]*>.*<\/body>/
		@emails = Email.limit( lim ).offset( off )
		respond_to do |format|
			format.json { render :json => @emails }
			format.html
		end # do format
	end # index
	
end # EmailsController
