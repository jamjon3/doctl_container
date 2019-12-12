pipeline {
  // gcr.io/cff-development/winrm_container:latest
  agent {
    docker {
      label 'master'
      image 'docker:latest'
      args """
        -u root:root --network=host 
        -v /var/run/docker.sock:/var/run/docker.sock
        -v /etc/docker/certs:/root/.docker 
        -v ${env.YMD_ANSIBLE_VAULT_KEY}:${env.YMD_ANSIBLE_VAULT_KEY} 
        --entrypoint=''
      """
      alwaysPull true
    }
  }
  environment {
    CLOUDSDK_CORE_DISABLE_PROMPTS = '1'
    GCP_AUTH_KIND = 'serviceaccount'
    ANSIBLE_HOST_KEY_CHECKING = 'False'
    DOCKER_CERT_PATH = "/root/.docker"
    KUBECONFIG = "/root/.kube/config"
  }
  stages {
    stage('Running Ansible Galaxy') {
      steps {
        checkout scm
        sshagent (credentials: [env.PODS_CRED]) {
          sh('rm -Rf /etc/ansible/roles')
          sh('#!/bin/sh -e\n' + '/usr/local/bin/ansible-galaxy install -r ansible/requirements.yml -p /etc/ansible/roles/ -f')
        }
      }
    }
    stage('Running Ansible') {
      environment {
        K8S_AUTH_KUBECONFIG = "${env.KUBECONFIG}"
        GCP_ACCOUNT_KEY = "googlecompute"
      }
      steps {
        withCredentials([usernamePassword(credentialsId: env.PODS_WIN_CRED, passwordVariable: 'TARGET_PASSWORD', usernameVariable: 'TARGET_USER')]) {
          sh("sed -i '1 s/^.*\$/#! \\/usr\\/bin\\/env python3/' /etc/ansible/roles/inventory/inventory.py")
          sh('#!/bin/sh -e\n' + "/usr/local/bin/ansible-playbook -i /etc/ansible/roles/inventory/inventory.py --vault-password-file=${CI_SECRET_KEY} --user=${TARGET_USER} ansible/playbook.yml --extra-vars 'target_hosts=${env.DEPLOY_HOST} deploy_env=${env.DEPLOY_ENV} ansible_user=${TARGET_USER} ansible_password=${TARGET_PASSWORD} package_revision=${env.BUILD_NUMBER} workspace=${env.WORKSPACE} app_name=${APP_NAME}' -vvvv")
        }
      }
    }
  }
}
