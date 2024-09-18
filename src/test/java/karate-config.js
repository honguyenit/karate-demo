function fn() {

  // Load environment variables from .env file
  var File = Java.type('java.io.File');
  var FileInputStream = Java.type('java.io.FileInputStream');
  var Properties = Java.type('java.util.Properties');
  var properties = new Properties();
  properties.load(new FileInputStream(new File('.env')));

  var env = karate.env; // get system property 'karate.env'
  karate.log('karate.env system property was:', env);
  if (!env) {
    env = 'dev';
  }
  var config = {
    //  apiURL: 'https://conduit-api.bondaracademy.com/api'
    apiURL: properties.getProperty('API_URL')
  }
  if (env == 'dev') {
    config.userName = properties.getProperty('DEV_USERNAME');
    config.userEmail = properties.getProperty('DEV_USEREMAIL');
    config.userPassword = properties.getProperty('DEV_USERPASSWORD');
  }
  if (env == 'qa') {
    config.userName = properties.getProperty('QA_USERNAME');
    config.userEmail = properties.getProperty('QA_USEREMAIL');
    config.userPassword = properties.getProperty('QA_USERPASSWORD');
  }

  var accessToken = karate.callSingle('classpath:helpers/CreateToken.feature', config).authToken
  karate.configure('headers', {Authorization: 'Token ' + accessToken})

  return config;
}