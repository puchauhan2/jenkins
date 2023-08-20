BUILD_ID=dontKillMe
mkdir -p pawlee-web
cd pawlee-web
mkdir -p angular wrapper/public/app/dist/
cd angular
git clone git@github.com:5ubbareddy/petboox.git .


git checkout hotfix/angular-wrapper-modifiction
git pull origin hotfix/angular-wrapper-modifiction
npm i
npm audit fix

cd ../wrapper
git clone git@github.com:5ubbareddy/petboox.git .
git checkout staging
git pull origin staging


cd ../angular
ng build --prod --base-href "/app/"

cd ..
cp -R angular/dist/* wrapper/public/app/dist/
cd  wrapper

npm i
npm audit fix --force

cat <<EOF > start.json
{
"apps": [
{
"name": "Webapp",
"script": "./server.js",
"instances": 1,
"exec_mode": "fork",
"env": {
"NODE_ENV": "production",
 }
},
]
}
EOF

pm2 start start.json
