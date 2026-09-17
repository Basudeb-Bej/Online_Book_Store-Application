package util;

import jakarta.servlet.ServletContext;
import jakarta.servlet.http.Part;

import java.io.IOException;
import java.io.InputStream;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.UUID;

public class FileUploadUtil {

    public static String saveImage(ServletContext context, Part part) throws IOException {
        if (part == null || part.getSize() <= 0) {
            return null;
        }

        String submittedFileName = part.getSubmittedFileName();
        if (submittedFileName == null || submittedFileName.trim().isEmpty()) {
            return null;
        }

        String safeFileName = Paths.get(submittedFileName).getFileName().toString();
        String storedFileName = UUID.randomUUID() + "_" + safeFileName;

        String imagesDirPath = context.getRealPath("/images");
        if (imagesDirPath == null) {
            String rootPath = context.getRealPath("");
            if (rootPath != null) {
                imagesDirPath = Paths.get(rootPath, "images").toString();
            }
        }
        if (imagesDirPath == null) {
            throw new IOException("Unable to resolve upload directory.");
        }

        Path imagesDir = Paths.get(imagesDirPath);
        Files.createDirectories(imagesDir);

        Path target = imagesDir.resolve(storedFileName);
        try (InputStream inputStream = part.getInputStream()) {
            Files.copy(inputStream, target);
        }

        return storedFileName;
    }
}
