FROM node:22-alpine AS build
RUN mkdir /web
WORKDIR /web

COPY frontend3/ /web/package3/
COPY frontend1/ /web/package1/
COPY frontend2/ /web/package2/

RUN cd ./package3 && npm install
RUN cd ./package1 && npm install
RUN cd ./package2 && npm install

RUN cd ./package3 && npm run build
RUN cd ./package1 && npm run build
RUN cd ./package2 && npm run build

FROM nginx:alpine AS run

RUN apk add nano

COPY --from=build /web/package3/dist /usr/share/nginx/html/frontend3
COPY --from=build /web/package1/dist /usr/share/nginx/html/frontend1
COPY --from=build /web/package2/dist /usr/share/nginx/html/frontend2

RUN mkdir /usr/share/nginx/html/assets

COPY --from=build /web/package3/dist/assets/ /usr/share/nginx/html/assets/
COPY --from=build /web/package1/dist/assets/ /usr/share/nginx/html/assets/
COPY --from=build /web/package2/dist/assets/ /usr/share/nginx/html/assets/

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]

