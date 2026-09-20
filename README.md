# ZehirMcNBT

Kontrollu Unicode + PersistentDataContainer test plugini.

## Windows'ta tek tikla JAR

1. ZIP'i cikart.
2. `build.bat` dosyasina cift tikla.
3. Derleme tamamlaninca kok klasorde `ZehirMcNBT.jar` ve `dist/ZehirMcNBT.jar` olusur.
4. JAR'i Paper sunucunun `plugins` klasorune koy.

`build.bat`, Gradle Wrapper varsa onu; yoksa sistemdeki Gradle'i kullanir. Gradle dokumantasyonu da Wrapper'i standart build yontemi olarak oneriyor. citeturn0search0turn0search1

## Komutlar

- `/zehir`
- `/zehir 64kb`
- `/zehir 256kb`
- `/zehir 1mb`
- `/zehir 5mb`
- `/zehir 10mb`
- `/zehir 15mb`
- `/zehir 20mb`

Bu proje gercek NBT acigi veya sunucu crash/DoS payload'i kullanmaz; kontrollu Unicode/PDC stres testi yapar.
