from invoke import task
import subprocess


@task()
def build(c, count=1):
    for _ in range(count):
        subprocess.Popen(['./build/estimation.app/Contents/MacOS/estimation'])
