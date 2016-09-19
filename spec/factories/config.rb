FactoryGirl.define  do
  skip_create
  factory :config, class: CarmenBuilds::Config do
    repo_url 'git@techinform.pro:carmen_client_app'
    project_name 'carmen_client_app'
    application_id 'ru.car4men.app.client'
    icon_url 'http://www.car4men.ru/images/app_logo_big.png'
  end

  factory :icon_config, class: CarmenBuilds::Config do
    tmpdir = FileUtils.mkdir_p(File.join(CarmenBuilds::Builders::Builder.tmp_path))
    git Git.init(File.join(tmpdir, 'carmen_app_test'))
    project_name 'carmen_client_app'
    application_id 'ru.car4men.app.client'
    icon_url 'http://www.car4men.ru/images/app_logo_big.png'
  end
end
