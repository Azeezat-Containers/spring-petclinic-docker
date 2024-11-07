FROM gcr.io/distroless/static-debian11
LABEL name="abisolaazeezat"
RUN mkdir /app
RUN groupadd appuser && useradd -r -g appuser appuser 
WORKDIR /app
USER appuser

# Corrected environment variable name for AWS credentials
# ENV AWS_ACCESS_KEY_ID=xxxxxx \
#     AWS_SECRET_ACCESS_KEY=xxxxxx+ \
#     AWS_DEFAULT_REGION=xxxxxx
# Define version arguments for Terraform and Packer
ARG T_VERSION='1.6.6'
ARG P_VERSION='1.8.0'

# Install dependencies
RUN apt update && apt install -y curl jq net-tools wget unzip \
    && apt install -y nginx iputils-ping

# Download, unzip, and set up Terraform and Packer
# RUN wget https://releases.hashicorp.com/terraform/${T_VERSION}/terraform_${T_VERSION}_linux_amd64.zip \
#     && wget https://releases.hashicorp.com/packer/${P_VERSION}/packer_${P_VERSION}_linux_amd64.zip \
#     && unzip terraform_${T_VERSION}_linux_amd64.zip \
#     && unzip packer_${P_VERSION}_linux_amd64.zip \
#     && chmod +x terraform packer \
#     && mv terraform packer /usr/local/bin/ \
#     && terraform version && packer version

# Start NGINX
USER appuser
CMD ["nginx", "-g", "daemon off;"]


##########################################################################

FROM openjdk:17-jdk-slim
WORKDIR /app
COPY . .
RUN ./mnvw package -DskipTests
EXPOSE 8080

CMD ["java", "-jar","target/*.jar"]