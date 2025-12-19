pipeline{
    agent any
        stages{
        stage('checkout'){
            steps{
                git 'https://github.com/chandra635313/java-hello-world-with-maven.git' 
            }
        }
        stage('build'){
            steps{
               sh 'mvn package'
            }
        }
            stage('test'){
            steps{
               sh 'mvn test'
            }
        }
    }
}
