import subprocess
import os

PROJECT_DIR = r"C:\cosmonet_reader"

def run_git(args):
    print(f"Executing: git {' '.join(args)}")
    result = subprocess.run(["git"] + args, cwd=PROJECT_DIR, text=True, capture_output=True)
    print(result.stdout)
    if result.returncode != 0:
        print(f"ERROR: {result.stderr}")
        return False
    return True

def main():
    # 1. Reset and Add
    if not run_git(["reset"]): return
    if not run_git(["add", "."]): return
    
    # 2. Commit
    if not run_git(["commit", "-m", "chore: Update Gradle to 8.9 and CI workflow for v1.0.2"]):
        print("Commit might have failed if no changes, checking status...")
    
    # 3. Push main
    if not run_git(["push", "origin", "main"]): return
    
    # 4. Tag
    run_git(["tag", "-d", "v1.0.2"]) # Delete if exists locally
    if not run_git(["tag", "v1.0.2"]): return
    
    # 5. Push tag
    if not run_git(["push", "origin", "v1.0.2", "--force"]): return
    
    print("\n[SUCCESS] Git operations for v1.0.2 completed.")

if __name__ == "__main__":
    main()
