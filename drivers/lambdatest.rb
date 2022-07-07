Capybara.register_driver :lambdatest do |app|
  url = "https://#{Howitzer.cloud_auth_login}:#{Howitzer.cloud_auth_pass}@hub.lambdatest.com/wd/hub"
  if Gem::Requirement.new(['>=4', '<5'])
                     .satisfied_by?(Gem::Version.new(Selenium::WebDriver::VERSION))
    reqiured_caps = required_cloud_caps
    caps = {
      'LT:Options' => {
        'user' => Howitzer.cloud_lambdatest_user,
        'accessKey' => Howitzer.cloud_lambdatest_accessKey,
        'build' => Howitzer.cloud_lambdatest_build,
        'name' => reqiured_caps['name'],
        'platformName' => reqiured_caps['platformName'],
        'resolution' => Howitzer.cloud_lambdatest_resolution
      },
      'browserName' => reqiured_caps['browserName'],
      'browserVersion' => reqiured_caps['browserVersion']
    }
    CapybaraHelpers.cloud_driver_ver_four(app, caps, url)
  elsif Gem::Requirement.new(['>=3', '<4'])
                        .satisfied_by?(Gem::Version.new(Selenium::WebDriver::VERSION))
    caps = CapybaraHelpers.required_cloud_caps.merge(
      project: Howitzer.cloud_lambdatest_project,
      build: Howitzer.cloud_lambdatest_build,
      nativeEvents: true,
      'ie.ensureCleanSession': 'true',
      acceptSslCerts: true
    )
    caps[:resolution] = Howitzer.cloud_lambdatest_resolution if Howitzer.cloud_lambdatest_resolution.present?
    caps[:device] = Howitzer.cloud_lambdatest_mobile_device if Howitzer.cloud_lambdatest_mobile_device.present?
    CapybaraHelpers.cloud_driver(app, caps, url)
  end
end

Capybara::Screenshot.class_eval do
  register_driver :lambdatest, &registered_drivers[:selenium]
end
