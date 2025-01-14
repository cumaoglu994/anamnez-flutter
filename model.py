import pandas as pd
from sklearn.model_selection import train_test_split
from sklearn.feature_extraction.text import CountVectorizer
from sklearn.preprocessing import LabelEncoder
from tensorflow.keras.models import Sequential
from tensorflow.keras.layers import Dense

# Orijinal veriyi okuma (dosya yolunu kendi dosyanıza göre düzenleyin)
file_path = "/content/symptoms_dataset.csv"  # Dosya yolunu kontrol edin
data = pd.read_csv(file_path)

# Veriyi uygun formata dönüştürme
diseases = data.columns.tolist()  # Hastalık isimleri
formatted_data = []

for disease in diseases:
    for symptoms in data[disease].dropna():  # Boş değerleri göz ardı etme
        formatted_data.append({'Symptoms': symptoms, 'Disease': disease})

formatted_df = pd.DataFrame(formatted_data)

# Giriş ve çıkışları ayırma
X = formatted_df['Symptoms']
y = formatted_df['Disease']

# Metinleri sayılara dönüştürme
vectorizer = CountVectorizer()
X_vectorized = vectorizer.fit_transform(X).toarray()

# Hastalıkları sayılara dönüştürme
label_encoder = LabelEncoder()
y_encoded = label_encoder.fit_transform(y)

# Veriyi eğitim ve test olarak ayırma
X_train, X_test, y_train, y_test = train_test_split(X_vectorized, y_encoded, test_size=0.2, random_state=42)

# Yapay sinir ağı modelini oluşturma
model = Sequential([
    Dense(128, activation='relu', input_dim=X_vectorized.shape[1]),  # İlk katman: 128 nöron, ReLU aktivasyon fonksiyonu
    Dense(64, activation='relu'),  # İkinci katman: 64 nöron, ReLU aktivasyon fonksiyonu
    Dense(len(label_encoder.classes_), activation='softmax')  # Çıkış katmanı: Hastalık sayısı kadar nöron, Softmax aktivasyon fonksiyonu
])

# Modeli yapılandırma
model.compile(optimizer='adam', loss='sparse_categorical_crossentropy', metrics=['accuracy'])


# Modeli eğitme
history = model.fit(X_train, y_train, epochs=20, batch_size=4, validation_split=0.1)

# Modeli değerlendirme
accuracy = model.evaluate(X_test, y_test, verbose=0)[1]
print(f"Model Doğruluğu: {accuracy * 100:.2f}%")

import matplotlib.pyplot as plt

# رسم دقة التدريب والتحقق
plt.plot(history.history['accuracy'], label='Training Accuracy')
plt.plot(history.history['val_accuracy'], label='Validation Accuracy')
plt.xlabel('Epochs')
plt.ylabel('Accuracy')
plt.title('Training and Validation Accuracy')
plt.legend()
plt.show()

# رسم خسارة التدريب والتحقق
plt.plot(history.history['loss'], label='Training Loss')
plt.plot(history.history['val_loss'], label='Validation Loss')
plt.xlabel('Epochs')
plt.ylabel('Loss')
plt.title('Training and Validation Loss')
plt.legend()
plt.show()


from sklearn.metrics import confusion_matrix, ConfusionMatrixDisplay

# التنبؤ بالقيم الخاصة ببيانات الاختبار
y_pred = model.predict(X_test).argmax(axis=1)
y_true = y_test

# إنشاء مصفوفة الالتباس
cm = confusion_matrix(y_true, y_pred, labels=range(len(label_encoder.classes_)))

# عرض المصفوفة
disp = ConfusionMatrixDisplay(confusion_matrix=cm, display_labels=label_encoder.classes_)
disp.plot(cmap=plt.cm.Blues)
plt.title('Confusion Matrix')
plt.show()

import numpy as np

# إدخال مثال
example_input = " Nefes Darlığı"
example_vectorized = vectorizer.transform([example_input]).toarray()

# الحصول على احتمالات التنبؤ
prediction_probs = model.predict(example_vectorized)[0]

# رسم الاحتمالات
plt.bar(label_encoder.classes_, prediction_probs)
plt.xlabel('Diseases')
plt.ylabel('Prediction Probability')
plt.title('Prediction Probabilities for Example Input')
plt.xticks(rotation=45, ha='right')
plt.show()



# رسم مقارنة بين الأداء
fig, ax = plt.subplots(1, 2, figsize=(12, 5))

# رسم الدقة
ax[0].plot(history.history['accuracy'], label='Training Accuracy')
ax[0].plot(history.history['val_accuracy'], label='Validation Accuracy')
ax[0].set_title('Accuracy')
ax[0].set_xlabel('Epochs')
ax[0].set_ylabel('Accuracy')
ax[0].legend()

# رسم الخسارة
ax[1].plot(history.history['loss'], label='Training Loss')
ax[1].plot(history.history['val_loss'], label='Validation Loss')
ax[1].set_title('Loss')
ax[1].set_xlabel('Epochs')
ax[1].set_ylabel('Loss')
ax[1].legend()

plt.tight_layout()
plt.show()


# Confusion Matrix
cm = confusion_matrix(y_test, y_pred, labels=model.classes_)
disp = ConfusionMatrixDisplay(confusion_matrix=cm, display_labels=model.classes_)
disp.plot(cmap=plt.cm.Blues)
plt.title("Confusion Matrix")
plt.show()




# Şikayeti analiz eden ve tahmin edilen hastalığı döndüren fonksiyon
def predict_disease(user_input):
    # Şikayeti eğitim verisine benzer bir formata dönüştürme
    user_vectorized = vectorizer.transform([user_input]).toarray()
    prediction = model.predict(user_vectorized)
    predicted_class = prediction.argmax(axis=1)  # En yüksek tahmin edilen sınıfı al
    disease = label_encoder.inverse_transform(predicted_class)  # Sayısal sınıfı etiketle geri çevir
    return disease[0]

# Kullanıcı giriş arayüzü
print("Hoş Geldiniz! Lütfen şikayetlerinizi girin (ör: Yüksek Ateş, Baş Ağrısı):")
user_input = input("Şikayetleriniz: ")  # Kullanıcıdan giriş al
predicted_disease = predict_disease(user_input)
print(f"Tahmin Edilen Hastalık: {predicted_disease}")
