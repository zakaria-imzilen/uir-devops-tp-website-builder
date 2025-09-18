pipeline {
  agent any

  options {
    skipDefaultCheckout()
    timestamps()
    disableConcurrentBuilds()
  }

  environment {
    CI = 'true'
    NODE_ENV = 'development'
  }

  stages {
    stage('prepare') {
      steps {
        checkout scm
        sh '''
          set -euxo pipefail
          echo "Node: $(node -v || echo missing)"
          echo "NPM:  $(npm -v || echo missing)"
          if [ -f package-lock.json ]; then
            npm ci
          elif [ -f package.json ]; then
            npm install
          else
            echo "No package.json found; nothing to install."
          fi
        '''
      }
    }

    stage('lint') {
      steps {
        sh '''
          set -euo pipefail
          if [ -f package.json ] && grep -Eq '"lint"[[:space:]]*:' package.json; then
            npm run lint
          else
            echo "No lint script found; skipping lint."
          fi
        '''
      }
    }

    stage('test') {
      steps {
        sh '''
          set -euo pipefail
          if [ -f package.json ] && grep -Eq '"test"[[:space:]]*:' package.json; then
            npm test -- --ci || npm test
          else
            echo "No test script found; skipping tests."
          fi
        '''
      }
    }

    stage('package') {
      steps {
        sh '''
          set -euo pipefail
          if [ -f package.json ] && grep -Eq '"build"[[:space:]]*:' package.json; then
            npm run build
          else
            echo "No build script found; attempting Next.js build via npx..."
            npx --yes next@latest build || echo "npx next build failed or not available."
          fi
        '''
        archiveArtifacts artifacts: '.next/**', allowEmptyArchive: true, onlyIfSuccessful: true
      }
    }

    stage('scan') {
      steps {
        sh '''
          set -euo pipefail
          if command -v npm >/dev/null 2>&1; then
            echo "Running npm audit (non-blocking)..."
            npm audit --production --audit-level=moderate || true
          else
            echo "npm not available; skipping security scan."
          fi
        '''
      }
    }

    stage('deploy:dry-run') {
      steps {
        sh '''
          set -euo pipefail
          echo "DRY-RUN deploy step"
          echo "Here you would run: npm run deploy or a deployment script."
          echo "No changes are made in dry-run."
        '''
      }
    }
  }

  post {
    success {
      echo 'Pipeline completed successfully.'
    }
    failure {
      echo 'Pipeline failed.'
    }
    always {
      echo 'Archiving optional artifacts...'
      junit testResults: 'junit*.xml', allowEmptyResults: true
      archiveArtifacts artifacts: 'coverage/**, junit*.xml', allowEmptyArchive: true
    }
  }
}
