node ("master") {
 def app

 stage('Clone repository') {
 /* Let's make sure we have the repository cloned to our workspace */

 checkout scm
 }

 stage('Build the image') {
 /* This builds the actual image; synonymous to
 * docker build on the command line */


 app = docker.build("matilda1/aiops:dev-dashboard-v${env.BUILD_NUMBER}")
 }

 stage('Push image') {
 /* Finally, we'll push the image with two tags:*/
 withCredentials([string(credentialsId: 'docker-hub', variable: 'dockerHubPwd')]) {
    sh "docker login -u mounikab19 -p ${dockerHubPwd}"

    app.push("dev-dashboard-v${env.BUILD_NUMBER}")


 }
 }
 
 stage('Deploy kubernetes') {
 sh "chmod +x changetag.sh"
 sh "./changetag.sh ${env.BUILD_NUMBER}"
 sshagent(['ec2-clientkey']) {
      script{
          sh 'ssh -t -t ec2-user@ip-172-31-25-43.ap-south-1.compute.internal -o StrictHostKeyChecking=no  "kubectl apply -f /var/lib/jenkins/workspace/aiops-shell/dynamic-dashboard/dashboard.yml"'
    }
 }
}
 
 
 stage('Remove Unused docker image') {
     sh "docker rmi matilda1/aiops:dev-dashboard-v${env.BUILD_NUMBER}"
    }
}