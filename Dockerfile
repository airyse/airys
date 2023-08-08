FROM nvidia/cuda:11.2.0-cudnn8-runtime-ubuntu20.04
RUN apt-get update \
    && DEBIAN_FRONTEND=noninteractive TZ=Etc/UTC apt-get -y install tzdata \
    && apt-get install -yy python3.8 python3.8-dev python3.8-venv python3-pip python3-opencv python-is-python3 build-essential python3-setuptools libtiff5-dev libjpeg8-dev libopenjp2-7-dev zlib1g-dev wget git \
    libfreetype6-dev liblcms2-dev libwebp-dev tcl8.6-dev tk8.6-dev python3-tk \
    libharfbuzz-dev libfribidi-dev libxcb1-dev \
    && apt clean
RUN mkdir -p /src
WORKDIR /src
RUN wget -P experiments/pretrained_models https://github.com/xinntao/Real-ESRGAN/releases/download/v0.1.0/RealESRGAN_x4plus.pth
RUN pip install torch==1.7.0 torchvision==0.8.1 torchaudio numpy==1.19.2 --extra-index-url https://download.pytorch.org/whl/cu113
RUN pip install basicsr
RUN pip install facexlib
RUN pip install gfpgan
COPY requirements.txt .
RUN pip install -r requirements.txt
COPY . .
RUN python setup.py develop
ENTRYPOINT ["python", "inference_realesrgan.py"]
