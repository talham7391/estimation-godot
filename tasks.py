from invoke import task
import subprocess


@task()
def build(c, count=1):
    for _ in range(count):
        c.run('cd build && unzip -u test.zip')
        subprocess.Popen(['./build/estimation.app/Contents/MacOS/estimation'])
