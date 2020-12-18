IMG_WKSPC=workspace
IMG_IDE=c9_ide_rails_5_2_4_4/ide
CON_OFF=c9_ide_rails_5_2_4_4_ide
IP := 127.0.0.1


# pick right tool for opening IDE in browser
ifeq ($(shell uname), Linux)
    OPEN=xdg-open
else
    OPEN=open
endif

run:
	docker run -d --name $(CON_OFF) \
	  --memory="1024m" --cpu-shares 512 \
	  -v '$(shell pwd)/workspace:/home/ubuntu/workspace' \
	  -w '/home/ubuntu/workspace' -e "IP=127.0.0.1" \
	  -e "PORT=8080" -p 5050:5050 -p 8080:8080 $(IMG_IDE) \
	  bash -lc 'node /var/c9sdk/server.js -w /home/ubuntu/workspace --auth : --listen 0.0.0.0 --port 5050'

open:
	$(OPEN) http://$(IP):5050/ide.html >/dev/null 2>&1

shell: run
	docker exec -it $(CON_OFF) /bin/bash

restart:
	docker restart $(CON_OFF) || true

stop:
	docker stop $(CON_OFF) || true
	docker rm $(CON_OFF) || true

build:
	docker build --no-cache -t $(IMG_IDE) .

rails_new:
	docker run \
	  -v '$(shell pwd)/workspace:/tmp/workspace' \
	  -w '/tmp/workspace' $(IMG_IDE) \
	  bash -lc 'cp -R /home/ubuntu/workspace /tmp/'

# removal
clean: stop
	docker rm $(CON_OFF) || true
	docker rmi $(IMG_IDE) || true

