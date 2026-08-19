@echo off
echo ===================================================
echo    Initializing Git and Pushing to GitHub
echo ===================================================
echo.

:: 1. Initialize local repository if not already done
if not exist ".git" (
    echo [1/4] Initializing Git repository...
    git init
    if %ERRORLEVEL% neq 0 (
        echo Error: Failed to initialize Git repository.
        pause
        exit /b %ERRORLEVEL%
    )
) else (
    echo [1/4] Git repository is already initialized.
)

:: 2. Stage and commit files
echo.
echo [2/4] Staging and committing project files...
git add .
git commit -m "Initial commit"
if %ERRORLEVEL% neq 0 (
    echo Note: Nothing to commit or commit failed.
)

:: 3. Prompt for GitHub repository URL
echo.
echo [3/4] GitHub Repository Setup
set /p REPO_URL="Enter your GitHub Repository URL (e.g. https://github.com/username/repo-name.git): "

if "%REPO_URL%"=="" (
    echo Error: No repository URL provided. Aborting push.
    echo Your changes are still committed locally.
    pause
    exit /b 1
)

:: 4. Set remote origin and push
echo.
echo [4/4] Setting remote and pushing code...
git remote remove origin >nul 2>&1
git remote add origin %REPO_URL%
git branch -M main

echo Pushing to 'main' branch...
git push -u origin main

if %ERRORLEVEL% neq 0 (
    echo.
    echo Push failed. Please check:
    echo 1. The GitHub repository URL is correct.
    echo 2. You have created the repository on GitHub.
    echo 3. You are logged into Git on your computer.
    echo.
) else (
    echo.
    echo Success! Your Flutter app has been pushed to GitHub.
)

pause
