#!/bin/bash

echo "🚀 Firebase에 배포 시작..."

# 로그인 (첫 실행 시만)
echo "📱 Firebase 인증..."
firebase login:ci --token "$FIREBASE_TOKEN" 2>&1 || true

# 배포
echo "📦 웹 앱 배포 중..."
firebase deploy --project i-tium-schedule 2>&1

echo "✅ 배포 완료!"
echo "🌐 앱이 다음에서 작동합니다:"
firebase hosting:channel:list --project i-tium-schedule 2>&1 | grep "https://" || echo "https://i-tium-schedule.web.app"
