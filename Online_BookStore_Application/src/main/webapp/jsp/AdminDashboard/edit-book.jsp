<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>

<!DOCTYPE html>
<html>
<head>

<meta charset="UTF-8">
<title>Edit Book</title>

<link
	href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"
	rel="stylesheet">

<style>
body {
	background: #f5f5f5;
}

.edit-card {
	border-radius: 15px;
}
</style>

</head>
<body>

	<%
String role = (String) session.getAttribute("role");
if(role == null || !role.equals("admin")){
    response.sendRedirect(request.getContextPath() + "/jsp/login.jsp");
    return;
}
%>

	<div class="container py-5">
		<div class="row justify-content-center">
			<div class="col-md-8">
				<div class="card shadow-lg edit-card">
					<div class="card-body p-5">
						<h2 class="text-center mb-4">Edit Book</h2>

						<c:if test="${not empty error}">
							<div class="alert alert-danger">${error}</div>
						</c:if>

						<form action="${pageContext.request.contextPath}/EditBookServlet"
							method="post" enctype="multipart/form-data">
							<input type="hidden" name="id" value="${book.id}"> <input
								type="hidden" name="existingImage" value="${book.image}">

							<div class="row">
								<div class="col-md-6 mb-3">
									<label class="form-label">Book Title</label> <input type="text"
										name="title" class="form-control" value="${book.title}"
										required>
								</div>
								<div class="col-md-6 mb-3">
									<label class="form-label">Author</label> <input type="text"
										name="author" class="form-control" value="${book.author}"
										required>
								</div>
							</div>

							<div class="row">
								<div class="col-md-4 mb-3">
									<label class="form-label">Price</label> <input type="number"
										step="0.01" name="price" class="form-control"
										value="${book.price}" required>
								</div>
								<div class="col-md-4 mb-3">
									<label class="form-label">Quantity</label> <input type="number"
										name="quantity" min="0" class="form-control"
										value="${book.quantity}" required>
								</div>
								<div class="col-md-4 mb-3">
									<label class="form-label">Category</label> <input type="text"
										name="category" class="form-control" value="${book.category}">
								</div>
								<div class="col-md-12 mb-3">
									<label class="form-label">Image Name</label> <input type="file"
										name="imageFile" class="form-control" accept="image/*">
								</div>
							</div>

							<c:set var="currentImageUrl" value="" />
							<c:if test="${not empty book.imageUrl}">
								<c:choose>
									<c:when
										test="${not empty book.imageUrl and (fn:startsWith(book.imageUrl, 'http://') or fn:startsWith(book.imageUrl, 'https://') or fn:startsWith(book.imageUrl, 'data:'))}">
										<c:set var="currentImageUrl" value="${book.imageUrl}" />
									</c:when>
									<c:otherwise>
										<c:set var="currentImageUrl"
											value="${pageContext.request.contextPath}${book.imageUrl}" />
									</c:otherwise>
								</c:choose>
							</c:if>

							<c:if test="${not empty currentImageUrl}">
								<div class="mb-3">
									<label class="form-label">Current Image</label><br> <img
										src="${currentImageUrl}" alt="${book.title}"
										style="max-width: 140px; max-height: 180px; border-radius: 10px; border: 1px solid #ddd; object-fit: cover;">
								</div>
							</c:if>

							<div class="mb-3">
								<label class="form-label">Description</label>
								<textarea name="description" class="form-control" rows="4">${book.description}</textarea>
							</div>

							<div class="d-flex gap-2 justify-content-end">
								<a href="${pageContext.request.contextPath}/AdminServlet"
									class="btn btn-secondary">Cancel</a>
								<button type="submit" class="btn btn-primary">Update
									Book</button>
							</div>
						</form>
					</div>
				</div>
			</div>
		</div>
	</div>

</body>
</html>
