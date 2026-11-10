# VisibleIsland

VisibleIsland mang đến một cách đơn giản để bật và tùy chỉnh Dynamic Island trên các thiết bị cũ.

![iOS](https://img.shields.io/badge/iOS-16.0--16.6.1-blue)
![Jailbreak](https://img.shields.io/badge/Jailbreak-rootless%20%7C%20roothide-purple)

## Tính năng

- Bật/tắt Dynamic Island chỉ với một công tắc
- Căn chỉnh Dynamic Island nằm ngay dưới notch thay vì bị lệch một nửa
- Tùy chỉnh vị trí Dynamic Island bằng offset X/Y tùy ý
- Tự động ẩn Dynamic Island khi không sử dụng
- Đưa notification banner xuống dưới island để dễ nhìn hơn
- Tùy chỉnh vị trí notification banner bằng offset X/Y
- Thay đổi kích thước (scale) Dynamic Island theo ý muốn
- Tùy chỉnh độ trong suốt của Dynamic Island
- Tùy chỉnh màu sắc Dynamic Island
- Ẩn viền outline của Dynamic Island

## Ảnh chụp màn hình

<p align="center">
  <img src="/Images/sc1.png" width="300" height="578" alt="Screenshot 1"/>
  <img src="/Images/sc2.png" width="300" height="578" alt="Screenshot 2"/>
  <img src="/Images/sc3.png" width="300" height="578" alt="Screenshot 3"/>
  <img src="/Images/sc4.png" width="300" height="578" alt="Screenshot 4"/>
  <img src="/Images/sc5.png" width="300" height="578" alt="Screenshot 5"/>
  <img src="/Images/sc6.png" width="300" height="578" alt="Screenshot 6"/>
</p>

## Lưu ý quan trọng

Hiện tại, tính năng tự động căn Dynamic Island nằm ngay dưới notch chỉ được hỗ trợ chính thức trên một số thiết bị bên dưới, do mình chưa có điều kiện test trên nhiều dòng máy.

Nếu thiết bị của bạn không nằm trong danh sách hỗ trợ đầy đủ, hãy sử dụng tính năng căn chỉnh vị trí tùy chỉnh bằng offset X/Y.

## Thiết bị được hỗ trợ đầy đủ

- iPhone X
- iPhone XS
- iPhone 11 Pro
- iPhone 13
- iPhone 13 Pro
- iPhone 14

## Thiết bị dùng offset “giả lập”

Một số thiết bị hiện đang sử dụng offset “giả lập”, được tính bằng cách đặt độ phân giải trên một thiết bị có cùng kích thước notch và tìm vị trí phù hợp cho island. Mình chưa chắc các offset này sẽ hoạt động chính xác trên tất cả thiết bị, nhưng về lý thuyết thì chúng nên hoạt động tốt.

Danh sách thiết bị dùng offset “giả lập”:

- iPhone XR
- iPhone 11
- iPhone XS Max
- iPhone 11 Pro Max
- iPhone 13 Mini
- iPhone 13 Pro Max

## Tương thích phiên bản iOS / jailbreak

Hỗ trợ đầy đủ cho iOS 16.0 – 16.6.1, bao gồm rootless hoặc roothide (Bootstrap + Serotonin).

## Sắp ra mắt

- Hỗ trợ chính thức thêm nhiều thiết bị
- Hỗ trợ iPad (có thể trong v2.1?)
- Sửa kích thước status bar để phù hợp hơn với Dynamic Island (có thể)

## Lỗi đã biết (sẽ sớm khắc phục)

- Xuất hiện hình chữ nhật đen phía sau một số thành phần (ví dụ: timer hoặc biểu tượng Face ID) khi dùng màu tùy chỉnh và/hoặc độ trong suốt tùy chỉnh
- Status bar bị đỏ (😳 rdar:45025538) trên iPhone XR và iPhone 11 — đã có bản sửa riêng nhưng sẽ sớm được tích hợp vào tweak

## Ghi chú phát hành

### 1.0-b1
- Bản beta đầu tiên

### 1.1-b1
- Thêm tùy chọn tắt Dynamic Island khi không sử dụng
- Thêm tùy chọn đưa notification banner xuống dưới Dynamic Island
- Thêm tùy chỉnh vị trí notification banner bằng offset X/Y

### 2.0
- Sửa lỗi Dynamic Island bị nhấp nháy và rung khi bật “Ẩn khi không sử dụng”
- Thêm tùy chỉnh màu sắc Dynamic Island
- Thêm tùy chọn ẩn viền outline của island
- Thêm tùy chỉnh kích thước (scale) Dynamic Island
- Thêm tùy chỉnh độ trong suốt của Dynamic Island
