## Analysis of the Model Approach to Customer Lifetime Value Prediction

### Business Problem

CLV merupakan score yang mendeskripsikan value customer bagi revenue perusahaan. <br>
Tinggi rendahnya score pada tiap customer diperoleh berdasarkan seberapa lama/sering customer menjalin hubungan dengan perusahaan, serta seberapa besar nilai masukan ataupun cost yang dihasilkan oleh customer bagi perusahaan.<br>
Mengetahui CLV score dapat membantu perusahaan dalam budgeting & financial planning, penerapan business & marketing strategy pada tiap jenis customer ataupun secara personalized nantinya.<br>
Oleh karena itu, **perusahaan memerlukan sistem yang bisa melakukan prediksi CLV score dengan minimum error sekecil mungkin agar perusahaan bisa mendapatkan gambaran (expected future) yang bisa dimanfaatkan untuk mengetahui potentially profitable customer, produk yang sedang diminati customer serta strategi yang tepat untuk meningkatkan retensi customer terhadap perusahaan.**

### Analytic Approach
Untuk menerapkan model yang tepat dalam memprediksi CLV, beberapa analisis data diperlukan sebagai berikut:
1. EDA, memastikan semua data dalam kondisi *cleaned*. Identifikasi korelasi untuk proses berikutnya (step 2.)
2. Feature Selection, memilh fitur yang tepat untuk diimplementasikan pada dataset yang tersedia.
3. Proses engineering fitur, dilakukan jika terdapat data categorical untuk diubah kedalam bentuk numerical.
4. Model Briefing & Selection, proses ini dilakukan untuk menganalisis bentuk data dan menentukan kemungkinan model yang tepat untuk diimplementasikan dan dianalisa lebih dalam. 
5. Analisis dan Pengujian Model, melakukan analisis terhadap model yang dipilih.
6. Menentukan pendekatan terbaik yang menghasilkan [minimum error terbaik](#metrics-evaluation).

### Metrics Evaluation
- MedAE: Nilai rata error dari hasil prediksi dalam skala unit.
- **MedAPE: Nilai rata error dari hasil prediksi dalam skala persen.** 
- **R2 Score: Mengukur kemampuan model dalam mengenali variansi data terhadap target**

Metrics tambahan:
- RMSE: Identifikasi besaran outlier pada error dalam skala unit.
- **MAPE: Identifikasi besaran outlier pada error dalam skala persen.**

notes: *text yang dibold menjadi penilaian utama*



