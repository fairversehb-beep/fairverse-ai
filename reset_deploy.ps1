$PROJECT_PATH = 'C:\Users\Administrator\Desktop\fairverse'
$GITHUB_URL = 'https://github.com/fairversehb-beep/fairverse-ai.git'
$PORT = 3000

Write-Host '🚀 Step 0: 进入项目目录'
Set-Location $PROJECT_PATH

Write-Host '🧹 Step 1: 删除旧依赖和 Git'
@('node_modules','dist','logs','.env','.git') | ForEach-Object {
    $path = Join-Path $PROJECT_PATH 
    if (Test-Path $path) { Remove-Item -Recurse -Force $path }
}

Write-Host '📄 Step 2: 生成 package.json（含 express）'
$packageJson = @{
    name = 'fairverse-ai'
    version = '1.0.0'
    main = 'index.js'
    type = 'module'
    scripts = @{ start = 'node index.js' }
    dependencies = @{ express = '^4.18.2' }
} | ConvertTo-Json -Depth 3
$packageJson | Out-File -Encoding UTF8 "$PROJECT_PATH\package.json"

Write-Host '📦 Step 3: 初始化 Git 仓库'
git init
git add .
git commit -m 'Initial commit: reset project'

# 安全判断 remote 是否存在
Try {
    git remote get-url origin | Out-Null
    git remote remove origin
} Catch {
    # remote 不存在，忽略
}

git remote add origin $GITHUB_URL

Write-Host '📤 Step 4: 强制推送到远程 GitHub'
git branch -M main
git push -u origin main --force

Write-Host '🔧 Step 5: 安装依赖'
npm install

Write-Host '🎬 Step 6: 启动本地服务'
$env:PORT = $PORT
Write-Host '⚠️ 本地服务启动中，CTRL+C 可停止'
npm start
