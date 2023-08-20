ANG_DIST="angular/dist"
ANGULAR_DIR="angular"
WRAPPER_DIR="wrapper"
WR_DIST="wrapper/dist"
BUILD_ID=dontKillMe
mkdir angular wrapper
cd  "$ANGULAR_DIR"
git checkout hotfix/angular-wrapper-modifiction
git pull origin hotfix/angular-wrapper-modifiction
npm i
npm audit fix

ng build --prod --base-href "/app/"

cd  "$WRAPPER_DIR"
git checkout staging
git pull origin staging

cd  "$WR_DIST"
rm -rf *

cd  "$ANG_DIST"

cp -Rv *  "$WR_DIST"

cd  "$WRAPPER_DIR"
npm i
npm audit fix

cat <<NGINX_HOST > start.json
{
  "apps": [
    {
      "name": "serverjs",
      "script": "./server.js",
      "instances": 1,
      "exec_mode": "fork",
      "env": {
        "NODE_ENV": "production",
      }
    },
  ]
}
NGINX_HOST

pm2 start start.json