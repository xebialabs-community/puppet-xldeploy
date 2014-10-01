class Deployment

  def initialize(communicator)
    @communicator=communicator
  end

  def repository
    return @repository if defined?(@repository)
    @repository = Repository.new(@communicator)
    @repository
  end

  def deployed_application_id(version, environment)
    application = repository.read(version)['application']
    environment + '/' + repository.read(application).name
  end

  def deployment_task(version, environment)
    application = repository.read(version)['application']
    if exists?(application, environment)
      update_deployment(version, deployed_application_id(version, environment))
    else
      initial_deployment(version, environment)
    end
  end

  def undeployment_task(version, environment)
    application = repository.read(version)['application']
    if exists?(application, environment)
      undeploy(deployed_application_id(version, environment))
    else
      raise "#{version} on ${environment} not found"
    end
  end

  def initial_deployment(version, environment)
    deployed_application = prepare_initial(version, environment)
    deployed_application = generate_all_deployeds(deployed_application)
    deployed_application = validate(deployed_application)
    deploy(deployed_application)
  end

  def update_deployment(version, deployed_application_id)
    deployed_application = prepare_update(version, deployed_application_id)
    deployed_application = prepare_auto_deployeds(deployed_application)
    deployed_application = validate(deployed_application)
    deploy(deployed_application)
  end

  def prepare_initial(version, environment)
    @communicator.do_get "/deployit/deployment/prepare/initial?version=#{version}&environment=#{environment}"
  end

  def prepare_update(version, deployed_application)
    @communicator.do_get "/deployit/deployment/prepare/update?version=#{version}&deployedApplication=#{deployed_application}"
  end

  def prepare_auto_deployeds(deployed_application_doc)
    @communicator.do_post "/deployit/deployment/prepare/deployeds", deployed_application_doc.to_s
  end

  def exists?(application, environment)
    doc = @communicator.do_get "/deployit/deployment/exists?application=#{application}&environment=#{environment}"
    '<boolean>true</boolean>' == doc.elements['//boolean'].to_s
  end

  def generate_all_deployeds(deployed_application_doc)
    @communicator.do_post "/deployit/deployment/generate/all", deployed_application_doc.to_s
  end


  def validate(deployed_application_doc)
    @communicator.do_post "/deployit/deployment/validate", deployed_application_doc.to_s
  end

  def deploy(deployed_application_doc)
    doc = @communicator.do_post "/deployit/deployment", deployed_application_doc.to_s
    doc.to_s
  end

  def rollback(taskid)
    doc = @communicator.do_post "/deployit/deployment/rollback/#{taskid}", ""
    doc.to_s
  end

  def undeploy(deployed_application)
    doc = @communicator.do_get "/deployit/deployment/prepare/undeploy?deployedApplication=#{deployed_application}"
    deploy doc
  end


end