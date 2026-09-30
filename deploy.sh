#!/bin/bash

# 빌드된 웹 파일을 gh-pages 브랜치에 배포

cd C:/Users/lasd7/Documents/ttobwa_app

echo "✅ Web 파일 배포 준비..."

# 빌드 폴더 확인
if [ ! -d "build/web" ]; then
    echo "❌ 에러: build/web 폴더 없음"
    exit 1
fi

echo "✅ build/web 폴더 확인됨"

# gh-pages 브랜치 생성 (존재하지 않으면)
git branch -D gh-pages 2>/dev/null || true
git checkout --orphan gh-pages

echo "✅ gh-pages 브랜치 생성됨"

# 모든 파일 제거
git rm -rf .

# 빌드된 파일만 추가
cp -r build/web/* .

echo "✅ 파일 복사 완료"

# .nojekyll 파일 생성 (GitHub Pages에서 필요)
touch .nojekyll

# 커밋
git add .
git commit -m "Deploy web app to GitHub Pages"

echo "✅ 커밋 완료"

# 푸시
git push -u origin gh-pages -f

echo "✅ 배포 완료!"
echo ""
echo "🌐 웹 앱 주소:"
echo "https://soon-moya.github.io/ttobwa/"

# main 브랜치로 돌아가기
git checkout main

echo "✅ main 브랜치로 돌아감"
