#!/bin/bash

# Netlify 部署前檢查腳本

echo "🔍 檢查 Netlify 部署準備..."
echo ""

# 顏色定義
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# 檢查計數器
CHECKS_PASSED=0
CHECKS_FAILED=0

# 檢查函數
check_file() {
    if [ -f "$1" ]; then
        echo -e "${GREEN}✓${NC} 檔案存在: $1"
        ((CHECKS_PASSED++))
        return 0
    else
        echo -e "${RED}✗${NC} 檔案不存在: $1"
        ((CHECKS_FAILED++))
        return 1
    fi
}

check_directory() {
    if [ -d "$1" ]; then
        echo -e "${GREEN}✓${NC} 目錄存在: $1"
        ((CHECKS_PASSED++))
        return 0
    else
        echo -e "${RED}✗${NC} 目錄不存在: $1"
        ((CHECKS_FAILED++))
        return 1
    fi
}

check_command() {
    if command -v "$1" &> /dev/null; then
        echo -e "${GREEN}✓${NC} 命令可用: $1"
        ((CHECKS_PASSED++))
        return 0
    else
        echo -e "${RED}✗${NC} 命令不存在: $1"
        ((CHECKS_FAILED++))
        return 1
    fi
}

echo "📁 檢查必要檔案..."
check_file "netlify.toml"
check_file "packages/blog-admin/package.json"
check_file "packages/blog-admin/vite.config.js"
check_file "packages/blog-admin/index.html"
check_directory "packages/blog-admin/src"
echo ""

echo "🔧 檢查開發工具..."
check_command "node"
check_command "npm"
check_command "git"
echo ""

echo "📦 檢查 Node.js 版本..."
NODE_VERSION=$(node -v | cut -d'v' -f2 | cut -d'.' -f1)
if [ "$NODE_VERSION" -ge 18 ]; then
    echo -e "${GREEN}✓${NC} Node.js 版本: v$(node -v) (>= 18)"
    ((CHECKS_PASSED++))
else
    echo -e "${RED}✗${NC} Node.js 版本過舊: v$(node -v) (需要 >= 18)"
    ((CHECKS_FAILED++))
fi
echo ""

echo "🔍 檢查 package.json 腳本..."
if grep -q '"build"' packages/blog-admin/package.json; then
    echo -e "${GREEN}✓${NC} build 腳本存在"
    ((CHECKS_PASSED++))
else
    echo -e "${RED}✗${NC} build 腳本不存在"
    ((CHECKS_FAILED++))
fi
echo ""

echo "🔐 檢查環境變數設置..."
echo -e "${YELLOW}⚠${NC}  請確認以下環境變數已在 Netlify 中設置："
echo "   - VITE_SUPABASE_URL"
echo "   - VITE_SUPABASE_ANON_KEY"
echo ""

echo "🧪 測試本地構建..."
echo "正在執行: cd packages/blog-admin && npm run build"
cd packages/blog-admin
if npm run build > /dev/null 2>&1; then
    echo -e "${GREEN}✓${NC} 本地構建成功"
    ((CHECKS_PASSED++))
    
    # 檢查構建輸出
    if [ -d "dist" ]; then
        echo -e "${GREEN}✓${NC} dist 目錄已生成"
        ((CHECKS_PASSED++))
        
        if [ -f "dist/index.html" ]; then
            echo -e "${GREEN}✓${NC} index.html 存在於 dist"
            ((CHECKS_PASSED++))
        else
            echo -e "${RED}✗${NC} index.html 不存在於 dist"
            ((CHECKS_FAILED++))
        fi
    else
        echo -e "${RED}✗${NC} dist 目錄未生成"
        ((CHECKS_FAILED++))
    fi
else
    echo -e "${RED}✗${NC} 本地構建失敗"
    echo "   請檢查構建錯誤並修復後再部署"
    ((CHECKS_FAILED++))
fi
cd ../..
echo ""

echo "📊 檢查結果總結"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo -e "通過: ${GREEN}$CHECKS_PASSED${NC}"
echo -e "失敗: ${RED}$CHECKS_FAILED${NC}"
echo ""

if [ $CHECKS_FAILED -eq 0 ]; then
    echo -e "${GREEN}✓ 所有檢查通過！可以開始部署到 Netlify${NC}"
    echo ""
    echo "下一步："
    echo "1. 推送代碼到 GitHub"
    echo "2. 在 Netlify Dashboard 匯入專案"
    echo "3. 設定環境變數"
    echo "4. 點擊 Deploy"
    echo ""
    echo "詳細步驟請參考: NETLIFY_ADMIN_DEPLOYMENT.md"
    exit 0
else
    echo -e "${RED}✗ 有 $CHECKS_FAILED 項檢查失敗，請修復後再部署${NC}"
    exit 1
fi
