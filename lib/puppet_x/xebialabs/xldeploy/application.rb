class Application

  def initialize(communicator)
    @communicator=communicator
  end

  def upload_package(id, path_to_archive)
    @communicator.do_post_multipart "/deployit/package/upload/#{path_to_archive}", {:fileData => path_to_archive}
  end

end