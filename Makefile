# Dependencies
# - make
# - ffmpeg

# VARIABLES

# Video
BASE_VIDEO_URL="http://distribution.bbb3d.renderfarming.net/video/mp4/bbb_sunflower_2160p_60fps_normal.mp4"

# Docker
LOCAL_SERVER_IMAGE_NAME = hls-server
LOCAL_SERVER_TAG = latest
LOCAL_CLIENT_IMAGE_NAME = hls-client
LOCAL_CLIENT_TAG = latest

DOCKER_REPOSITORY_SERVER_IMAGE_NAME = hls-server
DOCKER_REPOSITORY_SERVER_TAG = latest
DOCKER_REPOSITORY_CLIENT_IMAGE_NAME = hls-client
DOCKER_REPOSITORY_CLIENT_TAG = latest
REPOSITORY_HOST = atnog-harbor.av.it.pt/atnog

# HLS Videos
download-video:
	wget $(BASE_VIDEO_URL) -O full_video.mp4

trim-video:
	ffmpeg -i full_video.mp4 -t 10 -c copy input.mp4

create-30fps-video-streams:
	export VIDEO_FILE=$$( [ -f "input.mp4" ] && echo "../input.mp4" || echo "../full_video.mp4" ) \
	&& \
	mkdir -p streams \
	&& cd streams \
	&& \
	ffmpeg -report -i $$VIDEO_FILE \
	-filter_complex "\
	[0:v]split=8[v2160_30src][v1440_30src][v1080_30src][v720_30src][v480_30src][v360_30src][v240_30src][v144_30src]; \
	[v2160_30src]fps=30,scale=-2:2160[vout0_30]; \
	[v1440_30src]fps=30,scale=-2:1440[vout1_30]; \
	[v1080_30src]fps=30,scale=-2:1080[vout2_30]; \
	[v720_30src] fps=30,scale=-2:720 [vout3_30]; \
	[v480_30src] fps=30,scale=-2:480 [vout4_30]; \
	[v360_30src] fps=30,scale=-2:360 [vout5_30]; \
	[v240_30src] fps=30,scale=-2:240 [vout6_30]; \
	[v144_30src] fps=30,scale=-2:144 [vout7_30]" \
	-map [vout0_30] -map a:0 -c:v:0  libx264 -b:v:0 13411k -r 30 -c:a:0  aac -b:a:0 192k -ac 2 \
	-map [vout1_30] -map a:0 -c:v:1  libx264 -b:v:1 9011k  -r 30 -c:a:1  aac -b:a:1 192k -ac 2 \
	-map [vout2_30] -map a:0 -c:v:2 libx264 -b:v:2 5676k  -r 30 -c:a:2  aac -b:a:2 160k -ac 2 \
	-map [vout3_30] -map a:0 -c:v:3 libx264 -b:v:3 3440k  -r 30 -c:a:3  aac -b:a:3 128k -ac 2 \
	-map [vout4_30] -map a:0 -c:v:4 libx264 -b:v:4 1790k  -r 30 -c:a:4  aac -b:a:4 128k -ac 2 \
	-map [vout5_30] -map a:0 -c:v:5 libx264 -b:v:5 985k   -r 30 -c:a:5  aac -b:a:5 96k  -ac 2 \
	-map [vout6_30] -map a:0 -c:v:6 libx264 -b:v:6 510k   -r 30 -c:a:6  aac -b:a:6 64k  -ac 2 \
	-map [vout7_30] -map a:0 -c:v:7 libx264 -b:v:7 272k   -r 30 -c:a:7  aac -b:a:7 48k  -ac 2 \
	-f hls -hls_time 4 -hls_playlist_type vod \
	-hls_segment_filename "output_30fps_%v_%03d.ts" \
	-var_stream_map "\
	v:0,a:0 v:1,a:1 v:2,a:2 v:3,a:3 \
	v:4,a:4 v:5,a:5 v:6,a:6 v:7,a:7" \
	-master_pl_name master_30fps.m3u8 output_30fps_%v.m3u8 \
	&& cd ..

create-60fps-video-streams:
	export VIDEO_FILE=$$( [ -f "input.mp4" ] && echo "../input.mp4" || echo "../full_video.mp4" ) \
	&& \
	mkdir -p streams \
	&& cd streams \
	&& \
	ffmpeg -report -i $$VIDEO_FILE \
	-filter_complex "\
	[0:v]split=8[v2160_60][v1440_60][v1080_60][v720_60][v480_60][v360_60][v240_60][v144_60]; \
	[v2160_60]scale=-2:2160[vout0_60]; \
	[v1440_60]scale=-2:1440[vout1_60]; \
	[v1080_60]scale=-2:1080[vout2_60]; \
	[v720_60] scale=-2:720 [vout3_60]; \
	[v480_60] scale=-2:480 [vout4_60]; \
	[v360_60] scale=-2:360 [vout5_60]; \
	[v240_60] scale=-2:240 [vout6_60]; \
	[v144_60] scale=-2:144 [vout7_60]" \
	-map [vout0_60] -map a:0 -c:v:0 libx264 -b:v:0 13411k -r 60 -c:a:0 aac -b:a:0 192k -ac 2 \
	-map [vout1_60] -map a:0 -c:v:1 libx264 -b:v:1 9011k  -r 60 -c:a:1 aac -b:a:1 192k -ac 2 \
	-map [vout2_60] -map a:0 -c:v:2 libx264 -b:v:2 5676k  -r 60 -c:a:2 aac -b:a:2 160k -ac 2 \
	-map [vout3_60] -map a:0 -c:v:3 libx264 -b:v:3 3440k  -r 60 -c:a:3 aac -b:a:3 128k -ac 2 \
	-map [vout4_60] -map a:0 -c:v:4 libx264 -b:v:4 1790k  -r 60 -c:a:4 aac -b:a:4 128k -ac 2 \
	-map [vout5_60] -map a:0 -c:v:5 libx264 -b:v:5 985k   -r 60 -c:a:5 aac -b:a:5 96k  -ac 2 \
	-map [vout6_60] -map a:0 -c:v:6 libx264 -b:v:6 510k   -r 60 -c:a:6 aac -b:a:6 64k  -ac 2 \
	-map [vout7_60] -map a:0 -c:v:7 libx264 -b:v:7 272k   -r 60 -c:a:7 aac -b:a:7 48k  -ac 2 \
	-f hls -hls_time 4 -hls_playlist_type vod \
	-hls_segment_filename "output_60fps_%v_%03d.ts" \
	-var_stream_map "\
	v:0,a:0 v:1,a:1 v:2,a:2 v:3,a:3 \
	v:4,a:4 v:5,a:5 v:6,a:6 v:7,a:7" \
	-master_pl_name master_60fps.m3u8 output_60fps_%v.m3u8 \
	&& cd ..

create-master:
	cd streams && \
	sed '/#EXT-X-STREAM-INF:/ s/$$/,FRAME-RATE=60/' master_60fps.m3u8 > master_60fps_with_framerate.m3u8 && \
	sed '/#EXT-X-STREAM-INF:/ s/$$/,FRAME-RATE=30/' master_30fps.m3u8 > master_30fps_with_framerate.m3u8 && \
	cat master_60fps_with_framerate.m3u8 master_30fps_with_framerate.m3u8 > master.m3u8 && \
	cd ..

# Docker Container - HLS Server
docker-build-hls-server:
	docker build -t $(LOCAL_SERVER_IMAGE_NAME):$(LOCAL_SERVER_TAG) -f server/Dockerfile .

docker-tag-hls-server:
	docker tag $(LOCAL_SERVER_IMAGE_NAME):$(LOCAL_SERVER_TAG) $(REPOSITORY_HOST)/$(DOCKER_REPOSITORY_SERVER_IMAGE_NAME):$(DOCKER_REPOSITORY_SERVER_TAG)

docker-push-hls-server:
	docker push $(REPOSITORY_HOST)/$(DOCKER_REPOSITORY_SERVER_IMAGE_NAME):$(DOCKER_REPOSITORY_SERVER_TAG)

docker-clean-hls-server:
	docker image prune -f

docker-remove-hls-server:
	docker rmi $(LOCAL_SERVER_IMAGE_NAME):$(LOCAL_SERVER_TAG)

docker-hls-server: docker-build-hls-server docker-tag-hls-server docker-push-hls-server


# Docker Container - HLS Client
docker-build-hls-client:
	docker build -t $(LOCAL_CLIENT_IMAGE_NAME):$(LOCAL_CLIENT_TAG) -f client/Dockerfile .

docker-tag-hls-client:
	docker tag $(LOCAL_CLIENT_IMAGE_NAME):$(LOCAL_CLIENT_TAG) $(REPOSITORY_HOST)/$(DOCKER_REPOSITORY_CLIENT_IMAGE_NAME):$(DOCKER_REPOSITORY_CLIENT_TAG)

docker-push-hls-client:
	docker push $(REPOSITORY_HOST)/$(DOCKER_REPOSITORY_CLIENT_IMAGE_NAME):$(DOCKER_REPOSITORY_CLIENT_TAG)

docker-clean-hls-client:
	docker image prune -f

docker-remove-hls-client:
	docker rmi $(LOCAL_CLIENT_IMAGE_NAME):$(LOCAL_CLIENT_TAG)

docker-hls-client: docker-build-hls-client docker-tag-hls-client docker-push-hls-client

# Run
run:
	docker compose up -d

stop:
	docker compose down
