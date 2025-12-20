#!/bin/bash

# Steven Blog - 快速設定腳本

echo "🎉 歡迎使用 Steven Blog！"
echo ""

# 檢查 Node.js
if ! command -v node &> /dev/null; then
    echo "❌ 未偵測到 Node.js，請先安裝 Node.js >= 18"
    exit 1
fi

echo "✅ Node.js 版本: $(node -v)"
echo ""

# 檢查環境變數檔案
echo "📋 檢查環境變數設定..."

if [ ! -f "packages/blog-frontend/.env" ]; then
    echo "⚠️  前台 .env 檔案不存在"
    echo "   請複製 packages/blog-frontend/.env.example 為 .env 並填入您的 Supabase 金鑰"
    read -p "是否現在複製? (y/n) " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        cp packages/blog-frontend/.env.example packages/blog-frontend/.env
        echo "✅ 已建立 packages/blog-frontend/.env"
        echo "   請編輯此檔案並填入您的 Supabase 金鑰"
    fi
else
    echo "✅ 前台 .env 已存在"
fi

if [ ! -f "packages/blog-admin/.env" ]; then
    echo "⚠️  後台 .env 檔案不存在"
    read -p "是否現在複製? (y/n) " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        cp packages/blog-admin/.env.example packages/blog-admin/.env
        echo "✅ 已建立 packages/blog-admin/.env"
        echo "   請編輯此檔案並填入您的 Supabase 金鑰"
    fi
else
    echo "✅ 後台 .env 已存在"
fi

echo ""
echo "📦 安裝依賴..."

# 安裝前台依賴
if [ -d "packages/blog-frontend/node_modules" ]; then
    echo "✅ 前台依賴已安裝"
else
    echo "⏳ 安裝前台依賴..."
    cd packages/blog-frontend && npm install && cd ../..
    echo "✅ 前台依賴安裝完成"
fi

# 安裝後台依賴
if [ -d "packages/blog-admin/node_modules" ]; then
    echo "✅ 後台依賴已安裝"
else
    echo "⏳ 安裝後台依賴..."
    cd packages/blog-admin && npm install && cd ../..
    echo "✅ 後台依賴安裝完成"
fi

echo ""
echo "🎉 設定完成！"
echo ""
echo "📚 下一步："
echo "   1. 前往 https://supabase.com/ 建立專案"
echo "   2. 執行 supabase/schema.sql 中的 SQL"
echo "   3. 編輯 .env 檔案並填入 Supabase 金鑰"
echo "   4. 執行 'npm run dev:frontend' 啟動前台"
echo "   5. 執行 'npm run dev:admin' 啟動後台"
echo ""
echo "📖 詳細說明請參考："
echo "   - GETTING_STARTED.md  - 完整入門指南"
echo "   - supabase/README.md  - Supabase 設定"
echo "   - DEPLOYMENT.md       - 部署指南"
echo ""
