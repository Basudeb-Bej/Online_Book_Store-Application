<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>

<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<!DOCTYPE html>
<html>

<head>

<meta charset="UTF-8">

<title>Book Management</title>

<link
	href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"
	rel="stylesheet">

<link
	href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css"
	rel="stylesheet">

<style>
body {
	background: #f5f5f5;
}

.page-wrap {
	padding-left: 20.5rem;
	padding-right: 1.5rem;
}

.sidebar {
	position: fixed;
	top: 0;
	left: 0;
	width: 18.75rem;
	height: 100vh;
	overflow: hidden;
	display: flex;
	flex-direction: column;
	background: #212529;
	color: white;
	padding: 18px 16px;
	z-index: 1030;
}

.sidebar a {
	color: white;
	text-decoration: none;
	display: flex;
	align-items: center;
	gap: 10px;
	padding: 12px 14px;
	border-radius: 10px;
	margin-bottom: 6px;
	font-weight: 500;
}

.sidebar a:hover {
	background: #343a40;
}

.sidebar-menu {
	flex: 1;
	overflow-y: auto;
	padding-right: 4px;
}

.sidebar-footer {
	background: rgba(255, 255, 255, 0.08);
	border: 1px solid rgba(255, 255, 255, 0.1);
	border-radius: 16px;
	padding: 16px;
	margin-top: 14px;
}

.sidebar-avatar {
	width: 64px;
	height: 64px;
	border-radius: 50%;
	object-fit: cover;
	border: 3px solid rgba(255, 255, 255, 0.15);
}

.min-w-0 {
	min-width: 0;
}

.admin-main {
	padding-left: 1.5rem !important;
	padding-right: 0 !important;
}

.card {
	border: none;
	border-radius: 15px;
}

.panel-card {
	border-radius: 18px;
}

.stat-card {
	color: white;
	min-height: 120px;
}

.stat-card .card-body {
	display: flex;
	align-items: center;
	justify-content: space-between;
	gap: 1rem;
}

.stat-card .stat-icon {
	width: 56px;
	height: 56px;
	border-radius: 14px;
	background: rgba(255, 255, 255, 0.16);
	display: flex;
	align-items: center;
	justify-content: center;
	flex: 0 0 auto;
}

.stat-card .stat-copy {
	flex: 1;
	min-width: 0;
	text-align: right;
}

.stat-card h3 {
	font-size: 2rem;
	margin: 0;
}

.stat-card p {
	margin: 0;
	opacity: 0.9;
}

.book-thumb {
	width: 72px;
	height: 72px;
	object-fit: cover;
	border-radius: 8px;
	border: 1px solid #dee2e6;
}

@media ( max-width : 767.98px) {
	.page-wrap {
		padding-left: 0;
		padding-right: 0;
	}
	.sidebar {
		position: static;
		width: 100%;
		height: auto;
		overflow: visible;
	}
}
</style>

<script>
	function confirmLogout() {
		return confirm('Are you sure you want to logout?');
	}
</script>

</head>

<body>

	<%
	String role = (String) session.getAttribute("role");

	if (role == null || !role.equals("admin")) {

		response.sendRedirect(request.getContextPath() + "/jsp/login.jsp");
		return;
	}
	%>

	<div class="container-fluid page-wrap">

		<div class="row">

			<!-- SIDEBAR -->

			<div class="col-md-2 sidebar">

				<div class="sidebar-menu">

					<a href="#addBook"> <i class="bi bi-plus-circle"></i> Add Book
					</a> <a href="#bookList"> <i class="bi bi-journal-bookmark"></i>
						Manage Books
					</a> <a href="${pageContext.request.contextPath}/AdminProfileServlet">
						<i class="bi bi-person-lines-fill"></i> Profile
					</a> <a href="${pageContext.request.contextPath}/LogoutServlet"
						onclick="return confirmLogout();"> <i
						class="bi bi-box-arrow-right"></i> Logout
					</a>

				</div>

				<div class="sidebar-footer">
					<div class="d-flex align-items-center gap-3">
						<c:choose>
							<c:when
								test="${not empty adminProfile and not empty adminProfile.image}">
								<c:choose>
									<c:when
										test="${fn:startsWith(adminProfile.image, 'http://') or fn:startsWith(adminProfile.image, 'https://') or fn:startsWith(adminProfile.image, '/')}">
										<img class="sidebar-avatar" src="${adminProfile.image}"
											alt="${not empty adminProfile.name ? adminProfile.name : sessionScope.user}">
									</c:when>
									<c:otherwise>
										<c:url var="adminImageUrl"
											value="/images/${adminProfile.image}" />
										<img class="sidebar-avatar" src="${adminImageUrl}"
											alt="${not empty adminProfile.name ? adminProfile.name : sessionScope.user}">
									</c:otherwise>
								</c:choose>
							</c:when>
							<c:otherwise>
								<div
									class="sidebar-avatar d-flex align-items-center justify-content-center bg-secondary bg-opacity-50">
									<i class="bi bi-person-circle fs-2"></i>
								</div>
							</c:otherwise>
						</c:choose>

						<div class="min-w-0">
							<div class="fw-semibold text-truncate">${not empty adminProfile and not empty adminProfile.name ? adminProfile.name : sessionScope.user}
							</div>
							<div class="small text-white-50 text-truncate">${not empty adminProfile and not empty adminProfile.email ? adminProfile.email : sessionScope.email}
							</div>
						</div>
					</div>
				</div>

			</div>

			<!-- MAIN CONTENT -->

			<div class="col-md-10 p-4 admin-main">

				<div class="d-flex justify-content-between
align-items-center mb-4">

					<h2>Welcome Administrator</h2>

					<h5>${sessionScope.user}</h5>

				</div>

				<c:if test="${not empty requestScope.error}">
					<div class="alert alert-danger">${requestScope.error}</div>
				</c:if>

				<c:if test="${not empty sessionScope.error}">
					<div class="alert alert-danger">${sessionScope.error}</div>
					<%
					session.removeAttribute("error");
					%>
				</c:if>

				<c:if test="${not empty sessionScope.success}">
					<div class="alert alert-success">${sessionScope.success}</div>
					<%
					session.removeAttribute("success");
					%>
				</c:if>

				<!-- STATS CARDS -->

				<div class="row g-4 mb-4">

					<div class="col-md-3">
						<div class="card stat-card shadow bg-white text-dark">
							<div class="card-body">
								<div class="stat-icon">
									<i class="bi bi-people-fill fs-3"></i>
								</div>
								<div class="stat-copy">
									<p>Total Users</p>
									<h3>${totalUsers}</h3>
								</div>
							</div>
						</div>
					</div>

					<div class="col-md-3">
						<div class="card stat-card shadow bg-white text-dark">
							<div class="card-body">
								<div class="stat-icon">
									<i class="bi bi-book-fill fs-3"></i>
								</div>
								<div class="stat-copy">
									<p>Total Books</p>
									<h3>${totalBooks}</h3>
								</div>
							</div>
						</div>
					</div>

					<div class="col-md-3">
						<div class="card stat-card shadow bg-white text-dark">
							<div class="card-body">
								<div class="stat-icon">
									<i class="bi bi-bag-check-fill fs-3"></i>
								</div>
								<div class="stat-copy">
									<p>Total Sales</p>
									<h3>
										<fmt:formatNumber value="${totalSales}" type="number"
											maxFractionDigits="0" />
									</h3>
								</div>
							</div>
						</div>
					</div>

					<div class="col-md-3">
						<div class="card stat-card shadow bg-white text-dark">
							<div class="card-body">
								<div class="stat-icon">
									<i class="bi bi-cash-coin fs-3"></i>
								</div>
								<div class="stat-copy">
									<p>Total Revenue</p>
									<h3>
										₹
										<fmt:formatNumber value="${totalRevenue}" type="number"
											minFractionDigits="2" maxFractionDigits="2" />
									</h3>
								</div>
							</div>
						</div>
					</div>

				</div>

				<!-- ADD BOOK FORM -->

				<div class="card shadow mb-5 panel-card" id="addBook">

					<div class="card-body">

						<h3 class="mb-4">
							<i class="bi bi-plus-circle me-2 text-success"></i> Add New Book
						</h3>

						<form action="${pageContext.request.contextPath}/AdminServlet"
							method="post" enctype="multipart/form-data">

							<div class="row">

								<div class="col-md-6 mb-3">

									<label> Book Title </label> <input type="text" name="title"
										class="form-control" required>

								</div>

								<div class="col-md-6 mb-3">

									<label> Author </label> <input type="text" name="author"
										class="form-control" required>

								</div>

							</div>

							<div class="row">

								<div class="col-md-4 mb-3">

									<label> Price </label> <input type="number" name="price"
										class="form-control" required>

								</div>

								<div class="col-md-4 mb-3">

									<label> Quantity </label> <input type="number" name="quantity"
										class="form-control" min="0" value="1" required>

								</div>

								<div class="col-md-4 mb-3">

									<label> Category </label> <input type="text" name="category"
										class="form-control">

								</div>

							</div>

							<div class="row g-4 align-items-start">
								<div class="col-lg-4 mb-3">

									<label> Book Image </label> <input type="file" name="imageFile"
										class="form-control" accept="image/*">

								</div>

								<div class="col-lg-8 mb-0">

									<label> Description </label>

									<textarea name="description" class="form-control" rows="1"></textarea>

								</div>
							</div>

							<div class="d-grid gap-2 col-6 mx-auto">
								<button class="btn btn-outline-success" type="submit">Add Book</button>
							</div>

						</form>

					</div>
				</div>

				<!-- BOOK LIST -->

				<div class="card shadow panel-card" id="bookList">

					<div class="card-body">

						<div
							class="d-flex flex-wrap justify-content-between align-items-center gap-3 mb-4">
							<h3 class="mb-0">
								<i class="bi bi-journal-bookmark me-2 text-primary"></i> Manage
								Books
							</h3>

							<form class="ms-auto"
								action="${pageContext.request.contextPath}/AdminServlet"
								method="get">

								<div class="input-group flex-nowrap">
									<input type="text" name="keyword" value="${searchKeyword}"
										class="form-control"
										placeholder="Search by title, author, or category">

									<button type="submit" class="btn btn-dark">Search</button>
								</div>

							</form>
						</div>

						<table class="table table-bordered
table-hover">

							<thead class="table-dark">

								<tr>

									<th>ID</th>

									<th>Title</th>

									<th>Author</th>

									<th>Price</th>

									<th>Quantity</th>

									<th>Category</th>

									<th>Image</th>

									<th>Action</th>

								</tr>

							</thead>

							<tbody>

								<c:choose>
									<c:when test="${empty bookList}">
										<tr>
											<td colspan="8" class="text-center text-muted">No books
												found.</td>
										</tr>
									</c:when>
									<c:otherwise>
										<c:forEach var="book" items="${bookList}" varStatus="status">
											<tr>
												<td>${status.index + 1}</td>
												<td>${book.title}</td>
												<td>${book.author}</td>
												<td>₹ ${book.price}</td>
												<td><c:choose>
														<c:when test="${book.quantity > 0}">
															<span class="badge bg-success">${book.quantity}</span>
														</c:when>
														<c:otherwise>
															<span class="badge bg-danger">0</span>
														</c:otherwise>
													</c:choose></td>
												<td>${book.category}</td>
												<td><c:choose>
														<c:when
															test="${not empty book.imageUrl and (fn:startsWith(book.imageUrl, 'http://') or fn:startsWith(book.imageUrl, 'https://') or fn:startsWith(book.imageUrl, 'data:'))}">
															<img class="book-thumb" src="${book.imageUrl}"
																alt="${book.title}">
														</c:when>
														<c:when test="${not empty book.imageUrl}">
															<img class="book-thumb"
																src="${pageContext.request.contextPath}${book.imageUrl}"
																alt="${book.title}">
														</c:when>
														<c:otherwise>
															<span class="text-muted">No image</span>
														</c:otherwise>
													</c:choose></td>
												<td><a
													href="${pageContext.request.contextPath}/EditBookServlet?id=${book.id}"
													class="btn btn-outline-primary btn-sm"> Edit </a> <a
													href="${pageContext.request.contextPath}/DeleteBookServlet?id=${book.id}"
													class="btn btn-outline-danger btn-sm"
													onclick="return confirm('Delete this book?')"> Delete </a>
												</td>
											</tr>
										</c:forEach>
									</c:otherwise>
								</c:choose>

							</tbody>

						</table>

					</div>
				</div>

			</div>
		</div>
	</div>

</body>
</html>