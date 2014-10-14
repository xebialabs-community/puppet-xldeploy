class Tasks

  def initialize(communicator)
    @communicator=communicator
  end

  def start(taskid)
    @communicator.do_post "/deployit/task/#{taskid}/start", ''
  end

  def get(taskid)
    TaskInfo.new @communicator.do_get "/deployit/task/#{taskid}"
  end

  def start_and_wait(taskid)
    start taskid
    while not [:EXECUTED, :STOPPED].include? get(taskid).state
      sleep 1
    end
  end

  def cancel (taskid)
    @communicator.do_delete "/deployit/task/#{taskid}"
  end

  def archive(taskid)
    @communicator.do_post "/deployit/task/#{taskid}/archive", ''
  end

end
