/*
 * Copyright (C) 2013 The CyanogenMod Project
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

package org.cyanogenmod.hardware;

import org.cyanogenmod.hardware.util.FileUtils;
import java.io.File;

public class DisplayGammaCalibration {
    private static final String[] GAMMA_FILE = new String[] {
            "/sys/class/misc/samoled_color/red_v1_offset",
            "/sys/class/misc/samoled_color/green_v1_offset",
            "/sys/class/misc/samoled_color/blue_v1_offset"
    };
    private static final String GAMMA_FILE_V2 = "/sys/class/misc/colorcontrol/v1_offset";

    public static boolean isSupported() {
        if (new File(GAMMA_FILE_V2).exists()) {
            return true;
        }
        for (String filePath : GAMMA_FILE) {
            if (!new File(filePath).exists()) {
                return false;
            }
        }
        return true;
    }

    public static int getNumberOfControls() {
        return 1;
    }

    public static int getMaxValue(int control)  {
        return 20;
    }

    public static int getMinValue(int control)  {
        return -20;
    }

    public static String getCurGamma(int control) {
        if (new File(GAMMA_FILE_V2).exists()) {
            return FileUtils.readOneLine(GAMMA_FILE_V2);
        } else {
            StringBuilder values = new StringBuilder();
            for (String filePath : GAMMA_FILE) {
                values.append(FileUtils.readOneLine(filePath)).append(" ");
            }
            return values.toString();
        }
    }

    public static boolean setGamma(int control, String gamma) {
        if (new File(GAMMA_FILE_V2).exists()) {
            return FileUtils.writeLine(GAMMA_FILE_V2, gamma);
        } else {
            String[] valuesSplit = gamma.split(" ");
            boolean result = true;
            for (int i = 0; i < valuesSplit.length; i++) {
                String targetFile = GAMMA_FILE[i];
                result &= FileUtils.writeLine(targetFile, valuesSplit[i]);
            }
            return result;
        }
    }
}
