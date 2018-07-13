// The best way is to calculate the moments of your image using moments = CvInvoke.Moments(Image.Mat, false); The first parameter is the image the second is if you want it to use binary moments (geometric) or non binary (weighted where higher pixel intensities attract the centroid more).

// After getting the moments you can find the centroids X value using xpoint = (moments.M10/moments.00) and Y with ypoint = (moments.M01/moments.M00).

// The the centroid is = new Point(xpoint,ypoint)

// I hope this helps and here is some code as well:

moments = CvInvoke.Moments(image.Mat, false);
WeightedCentroid = new Point((int)(moments.M10 / moments.M00), (int)(moments.M01 / moments.M00));

//*******************

// Possible color detection function

private static void GetRedPixelMask(IInputArray image, IInputOutputArray mask)
      {
         bool useUMat;
         using (InputOutputArray ia = mask.GetInputOutputArray())
            useUMat = ia.IsUMat;

         using (IImage hsv = useUMat ? (IImage)new UMat() : (IImage)new Mat())
         using (IImage s = useUMat ? (IImage)new UMat() : (IImage)new Mat())
         {
            CvInvoke.CvtColor(image, hsv, ColorConversion.Bgr2Hsv);
            CvInvoke.ExtractChannel(hsv, mask, 0);
            CvInvoke.ExtractChannel(hsv, s, 1);

            //the mask for hue less than 20 or larger than 160
            using (ScalarArray lower = new ScalarArray(20))         // change here
            using (ScalarArray upper = new ScalarArray(160))       // change here
               CvInvoke.InRange(mask, lower, upper, mask);
            CvInvoke.BitwiseNot(mask, mask);

            //s is the mask for saturation of at least 10, this is mainly used to filter out white pixels
            CvInvoke.Threshold(s, s, 10, 255, ThresholdType.Binary);
            CvInvoke.BitwiseAnd(mask, s, mask, null);

         }
      }
