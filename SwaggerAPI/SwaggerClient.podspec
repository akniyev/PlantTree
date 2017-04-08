Pod::Spec.new do |s|
  s.name = 'SwaggerClient'
  s.ios.deployment_target = '9.0'
  s.osx.deployment_target = '10.11'
  s.version = '0.0.2'
  s.source = { :git => 'git@github.com:swagger-api/swagger-mustache.git', :tag => 'v1.0.0' }
  s.authors = 'Swagger Codegen'
  s.license = 'Proprietary'
  s.source_files = 'SwaggerClient/Classes/Swaggers/**/*.swift'
  s.dependency 'Alamofire', '~> 4.0'
  s.summary = 'Swagger Swift SDK'
  s.homepage = "http://swagger.io/"
end
