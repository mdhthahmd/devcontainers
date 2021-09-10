set NODE_VERSION = "lts/*" 
docker build --build-arg VARIANT="5.0" --build-arg  NODE_VERSION="lts/*"  -t "dotnet5.0" .  

so nodejs available immediatly