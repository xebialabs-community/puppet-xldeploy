require 'rexml/document'

class TaskInfo

  attr_reader :current_step, :total_steps, :failures, :state, :owner, :start_date, :completion_date,
                :application, :environment, :taskType, :environment_id, :version

  def initialize(doc)
    @current_step = doc.root.attributes['currentStep']
    @total_steps = doc.root.attributes['totalSteps']
    @failures = doc.root.attributes['failures']
    @state = doc.root.attributes['state'].intern
    @owner = doc.root.attributes['owner']

    #@start_date = doc.root.elements['startDate'].to_a.first.text
    #@completion_date = doc.root.elements['completionDate'].to_a.first.text

    @application = doc.root.elements().to_a('metadata/application').first.text
    @environment = doc.root.elements().to_a('metadata/environment').first.text
    @task_type = doc.root.elements().to_a('metadata/taskType').first.text.intern
    @environment_id = doc.root.elements().to_a('metadata/environment_id').first.text
    @version = doc.root.elements().to_a('metadata/version').first.text

  end

  def to_s
    "TaskInfo #{@state} : #{@current_step}/#{@total_steps} #{@application}/#{@version} -> #{@environment_id}"
  end

end