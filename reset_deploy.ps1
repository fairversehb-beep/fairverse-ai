# =========================
# ⚡ Fairverse Citizen AI 全覆盖重置 & 本地测试
# =========================
$PROJECT_PATH = 'C:\Users\Administrator\Desktop\fairverse'  # 修改为你的本地项目路径
$GITHUB_URL = 'https://github.com/fairversehb-beep/fairverse-ai.git'  # GitHub 仓库 URL
$PORT = 3000

Write-Host '🚀 Step 0: 进入项目目录'
Set-Location $PROJECT_PATH

Write-Host '🧹 Step 1: 删除旧文件和依赖'
@('node_modules','dist','logs','.env','.git') | ForEach-Object {
    if (Test-Path "$PROJECT_PATH\") { Remove-Item -Recurse -Force "$PROJECT_PATH\" }
}

Write-Host '📄 Step 2: 生成干净的 package.json'
$packageJson = @{
    name = 'fairverse-ai'
    version = '1.0.0'
    main = 'index.js'
    scripts = @{ start = 'node index.js' }
    dependencies = @{}
} | ConvertTo-Json -Depth 3
$packageJson | Out-File -Encoding UTF8 "$PROJECT_PATH\package.json"

Write-Host '📦 Step 3: 初始化 Git 仓库'
git init
git add .
git commit -m 'Initial commit: reset project'
git remote remove origin -ErrorAction SilentlyContinue
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
