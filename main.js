require('coffee-script/register');

var fs = require('fs')
  , xml2js = require('xml2js');

try {
  var appsettings = fs.readFileSync(process.env.APPSETTINGS_PATH);

  var parseOptions = {
    trim: true,
    explicitArray: false
  };

  xml2js.parseString(appsettings, parseOptions, function(err, settings) {
    if(err) return console.error(err);
    process.env.AWS_ACCESS_KEY_ID = settings.credentials.accesskeyid;
    process.env.AWS_SESSION_TOKEN = settings.credentials.sessiontoken;
    process.env.AWS_SECRET_ACCESS_KEY = settings.credentials.secretaccesskey;
  });
}
catch (e) {
  console.log('Appsettings not found. AWS SDk will try to get credentials fom IAM role')
}
finally {
  require('./app.coffee');
}