Add-Type -AssemblyName System.Drawing
$bmp = [System.Drawing.Bitmap]::FromFile("$PWD\assets\images\Gemini_Generated_Image_n6pe37n6pe37n6pe.png")
$color = $bmp.GetPixel(0,0)
$bmp.MakeTransparent($color)
$bmp.Save("$PWD\assets\images\logo_transparent.png", [System.Drawing.Imaging.ImageFormat]::Png)
$bmp.Dispose()
Write-Host "Logo background made transparent successfully!"
