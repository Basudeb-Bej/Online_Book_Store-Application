package model;

public class Book {
    private int id;
    private String title;
    private String author;
    private double price;
    private String category;
    private String description;
    private String image;
    private String imageUrl;
    private String purchasedAt;
    private int quantity = 1;

    private String normalizeImageReference(String value) {
        if (value == null || value.trim().isEmpty()) {
            return "";
        }

        String normalized = value.trim().replace("\\", "/");

        if (normalized.startsWith("http://") || normalized.startsWith("https://") || normalized.startsWith("data:")) {
            return normalized;
        }

        if (normalized.startsWith("/")) {
            return normalized;
        }

        if (normalized.startsWith("images/")) {
            return "/" + normalized;
        }

        int lastSlash = normalized.lastIndexOf('/');
        if (lastSlash >= 0) {
            normalized = normalized.substring(lastSlash + 1);
        }

        return normalized.isEmpty() ? "" : "/images/" + normalized;
    }

    // DEFAULT CONSTRUCTOR

    public Book() {
    }

    // GETTERS AND SETTERS

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public String getAuthor() {
        return author;
    }

    public void setAuthor(String author) {
        this.author = author;
    }

    public double getPrice() {
        return price;
    }

    public void setPrice(double price) {
        this.price = price;
    }

    public String getCategory() {
        return category;
    }

    public void setCategory(String category) {
        this.category = category;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public String getImage() {
        return image;
    }

    public void setImage(String image) {
        this.image = image;
    }

    public String getImageUrl() {
        if (imageUrl != null && !imageUrl.trim().isEmpty()) {
            return normalizeImageReference(imageUrl);
        }

        return normalizeImageReference(image);
    }

    public void setImageUrl(String imageUrl) {
        this.imageUrl = normalizeImageReference(imageUrl);
    }

    public String getPurchasedAt() {
        return purchasedAt;
    }

    public void setPurchasedAt(String purchasedAt) {
        this.purchasedAt = purchasedAt;
    }

    public int getQuantity() {
        return quantity;
    }

    public void setQuantity(int quantity) {
        this.quantity = Math.max(0, quantity);
    }
}