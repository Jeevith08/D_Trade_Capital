import subprocess

r = subprocess.run(['dart', 'format', 'lib/screens/home_page.dart'], capture_output=True, text=True)
print("STDOUT:", r.stdout)
print("STDERR:", r.stderr)
