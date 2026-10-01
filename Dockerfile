# stage 1: ตรวจ HTML — ถ้า html-validate ไม่ผ่าน build จะหยุดที่นี่
FROM node:24-alpine AS check
WORKDIR /app
COPY package.json package-lock.json ./
RUN npm ci --ignore-scripts
COPY .htmlvalidate.json ./
COPY site ./site
RUN npm run lint

# stage 2: เสิร์ฟหน้าเว็บด้วย nginx แบบไม่ใช้สิทธิ์ root ที่พอร์ต 8080 (ใช้ดูในเครื่องและ smoke test ใน CI)
# คัดลอกจาก stage check เพื่อบังคับให้ด่านตรวจต้องรันก่อนเสมอ
FROM nginxinc/nginx-unprivileged:1.28-alpine
COPY --from=check /app/site /usr/share/nginx/html
