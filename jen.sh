pipeline {
    agent any

    stages {
        stage('Cloning AngularCodeWeb') {
            steps {
                
				sh '''rm -rf *
				mkdir -p angular wrapper/public/app/dist
				cd angular
				git clone git@github.com:5ubbareddy/petboox.git .'''
            }
            
        }
        stage('Pull AngularWrapper ') {
            steps {
                
				sh ''' cd angular
				git checkout hotfix/angular-wrapper-modifiction
				git pull origin hotfix/angular-wrapper-modifiction
				npm i
				npm audit fix'''
            }
            
        }
        stage('Pull staging WebApp ') {
            steps {
                
				sh ''' cd wrapper
				git checkout staging
                git pull origin staging
                npm i
                npm audit fix'''
            }	}
        stage('Built AngularWrapper ') {
            steps {
                
				sh ''' cd angular
				ng build --prod --base-href "/app/"'''
            }}
         
        stage('Making built for deployment ') {
            steps {
                
				sh ''' cd angular/dist
				cp -Rv * wrapper/public/app/dist
				cd  "$WRAPPER_DIR"
                npm i
                npm audit fix --force''' }}
         stage('Running PetbooxWebApp ') {
            steps {
                
				sh ''' cd wrapper
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
                }'''
                
                sh '''pm2 start start.json'''
                    }     
        }
        
    }
	}