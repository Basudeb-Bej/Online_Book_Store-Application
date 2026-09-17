<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>

<!DOCTYPE html>
<html>
<head>

<title>Books</title>

<link
	href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"
	rel="stylesheet">

<link
	href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css"
	rel="stylesheet">
<script
	src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>

<style>
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
	background: #111827;
	color: #fff;
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

.sidebar a:hover, .sidebar a.active {
	background: rgba(255, 255, 255, 0.12);
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

.user-avatar {
	width: 64px;
	height: 64px;
	border-radius: 50%;
	background: rgba(255, 255, 255, 0.14);
	overflow: hidden;
	border: 3px solid rgba(255, 255, 255, 0.15);
	display: flex;
	align-items: center;
	justify-content: center;
	flex: 0 0 auto;
}

.profile-avatar-img {
	width: 100%;
	height: 100%;
	object-fit: cover;
	display: block;
	border-radius: 50%;
}

.min-w-0 {
	min-width: 0;
}

.content-card {
	border: none;
	border-radius: 18px;
}

.book-cover {
	width: 100%;
	height: 220px;
	object-fit: cover;
	border-top-left-radius: 0.5rem;
	border-top-right-radius: 0.5rem;
}

.book-card {
	border: none;
	border-radius: 16px;
	overflow: hidden;
	height: 100%;
	display: flex;
	flex-direction: column;
	width: 100%;
}

.book-cover-fallback {
	height: 220px;
	background: linear-gradient(135deg, #f8f9fa, #e9ecef);
	display: flex;
	align-items: center;
	justify-content: center;
}

.book-card .card-body {
	display: flex;
	flex-direction: column;
	flex: 1;
	gap: 0.85rem;
}

.book-summary {
	display: -webkit-box;
	-webkit-line-clamp: 3;
	-webkit-box-orient: vertical;
	overflow: hidden;
}

.book-footer {
	margin-top: auto;
}

.books-grid .col {
	display: flex;
}

/* Search bar styles */
.search-section {
	background: #fff;
	border-radius: 16px;
	padding: 1.25rem 1.5rem;
	box-shadow: 0 1px 3px rgba(0, 0, 0, 0.08);
	margin-bottom: 1.5rem;
}

.search-form .input-group {
	border-radius: 12px;
	overflow: hidden;
	border: 1px solid #dee2e6;
	transition: border-color 0.2s, box-shadow 0.2s;
}

.search-form .input-group:focus-within {
	border-color: #86b7fe;
	box-shadow: 0 0 0 0.25rem rgba(13, 110, 253, 0.15);
}

.search-form .form-control {
	border: none;
	padding: 0.6rem 1rem;
	font-size: 0.95rem;
}

.search-form .form-control:focus {
	box-shadow: none;
}

.search-form .btn-search {
	border: none;
	background: transparent;
	padding: 0.6rem 1.2rem;
	color: #6c757d;
}

.search-form .btn-search:hover {
	color: #0d6efd;
	background: rgba(13, 110, 253, 0.08);
}

.search-form .btn-search:active {
	background: rgba(13, 110, 253, 0.15);
}

.search-info {
	font-size: 0.85rem;
	color: #6c757d;
	margin-top: 0.5rem;
}

.search-info .clear-search {
	color: #0d6efd;
	text-decoration: none;
	font-weight: 500;
	margin-left: 0.5rem;
}

.search-info .clear-search:hover {
	text-decoration: underline;
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

</head>

<body class="bg-light">

	<%
	String role = (String) session.getAttribute("role");
	if (role == null) {
		response.sendRedirect(request.getContextPath() + "/jsp/login.jsp");
		return;
	}
	if ("admin".equals(role)) {
		response.sendRedirect(request.getContextPath() + "/AdminServlet");
		return;
	}
	%>

	<div class="container-fluid page-wrap">
		<div class="row">
			<div class="col-md-2 sidebar">
				<div class="d-flex align-items-center gap-3 mb-4">
					<div class="user-avatar">
						<c:choose>
							<c:when test="${not empty sessionScope.profileImage}">
								<img class="profile-avatar-img"
									src="${pageContext.request.contextPath}/images/${sessionScope.profileImage}"
									alt="${sessionScope.user}">
							</c:when>
							<c:otherwise>
								<i class="bi bi-person-circle fs-2"></i>
							</c:otherwise>
						</c:choose>
					</div>
					<div class="min-w-0">
						<div class="fw-semibold text-truncate">${sessionScope.user}</div>
						<div class="small text-white-50 text-truncate">${sessionScope.email}</div>
					</div>
				</div>

				<div class="sidebar-menu">
					<a href="${pageContext.request.contextPath}/dashboard"><i
						class="bi bi-speedometer2"></i>Dashboard</a> <a class="active"
						href="${pageContext.request.contextPath}/books"><i
						class="bi bi-journal-bookmark"></i>Browse Books</a> <a
						href="${pageContext.request.contextPath}/CartServlet"><i
						class="bi bi-cart3"></i>My Books</a> <a
						href="${pageContext.request.contextPath}/dashboard#accountSection"><i
						class="bi bi-person-lines-fill"></i>Profile</a> <a
						href="${pageContext.request.contextPath}/LogoutServlet"
						onclick="return confirm('Are you sure you want to logout?');"><i
						class="bi bi-box-arrow-right"></i>Logout</a>
				</div>

				<div class="sidebar-footer">
					<div class="small text-white-50 mb-1">Available books</div>
					<div class="h4 mb-0">${fn:length(bookList)}</div>
					<hr class="border-light opacity-25 my-3">
					<!-- div class="small text-white-50 mb-1">Cart items</div>
					<div class="h5 mb-0">${cartCount}</div>
					<hr class="border-light opacity-25 my-3"-->
					<div class="small text-white-50 mb-1">Purchased books</div>
					<div class="h5 mb-0">${myBookCount}</div>
				</div>
			</div>

			<div class="col-md-10 p-4">
				<c:if test="${not empty sessionScope.error}">
					<div class="alert alert-danger shadow-sm mb-4">${sessionScope.error}</div>
					<%
					session.removeAttribute("error");
					%>
				</c:if>

				<c:if test="${not empty sessionScope.success}">
					<div class="alert alert-success shadow-sm mb-4">${sessionScope.success}</div>
					<%
					session.removeAttribute("success");
					%>
				</c:if>

				<div
					class="d-flex flex-wrap justify-content-between align-items-center gap-2 mb-4">
					<div>
						<h2 class="mb-1">Browse Books</h2>
						<div class="text-muted">Explore the catalog and buy any
							available book right away.</div>
					</div>

					<!-- Search + Dashboard -->
					<div class="d-flex align-items-center gap-2 flex-wrap">

						<form class="d-flex"
							action="${pageContext.request.contextPath}/SearchServlet"
							method="get">

							<div class="input-group input-group-sm">
								<input type="text" name="keyword" value="${searchKeyword}"
									class="form-control" placeholder="Search books...">

								<button type="submit" class="btn btn-dark">
									<i class="bi bi-search"></i>
								</button>
							</div>
						</form>

						<a class="btn btn-outline-primary btn-sm"
							href="${pageContext.request.contextPath}/dashboard"> <i
							class="bi bi-speedometer2"></i> Dashboard
						</a>

					</div>
				</div>

				<div
					class="row row-cols-1 row-cols-md-2 row-cols-xl-3 g-4 books-grid">

					<c:forEach var="book" items="${bookList}">

						<div class="col">

							<div class="card shadow-sm book-card">


								<c:choose>
									<c:when
										test="${not empty book.imageUrl and (fn:startsWith(book.imageUrl, 'http://') or fn:startsWith(book.imageUrl, 'https://') or fn:startsWith(book.imageUrl, 'data:'))}">
										<img class="book-cover" src="${book.imageUrl}"
											alt="${book.title}">
									</c:when>
									<c:when test="${not empty book.imageUrl}">
										<img class="book-cover"
											src="${pageContext.request.contextPath}${book.imageUrl}"
											alt="${book.title}">
									</c:when>
									<c:otherwise>
										<div
											class="book-cover-fallback d-flex align-items-center justify-content-center text-muted">
											<div class="text-center">
												<i class="bi bi-book fs-1 d-block mb-2"></i> No Image
											</div>
										</div>
									</c:otherwise>
								</c:choose>
								<div class="card-body">
									<div>
										<h5 class="mb-1">${book.title}</h5>
										<div class="text-muted small">by ${book.author}</div>
									</div>

									<p class="book-summary text-muted small mb-0 flex-grow-1">
										${book.description}</p>

									<div class="book-footer">
										<div
											class="d-flex justify-content-between align-items-center gap-2 mb-2">
											<strong class="text-success">&#8377; ${book.price}</strong>
											<c:choose>
												<c:when test="${book.quantity > 0}">
													<span class="badge bg-success-subtle text-success">In
														Stock</span>
												</c:when>
												<c:otherwise>
													<span class="badge bg-danger-subtle text-danger">Out
														of Stock</span>
												</c:otherwise>
											</c:choose>
										</div>
										<div class="small text-muted mb-3">Available quantity:
											${book.quantity}</div>

										<c:choose>
											<c:when test="${book.quantity > 0}">
												<button type="button"
													class="btn btn-primary w-100 buy-now-btn"
													data-bs-toggle="modal" data-bs-target="#paymentModal"
													data-book-id="${book.id}" data-book-title="${book.title}"
													data-action="buyNow">Buy Now</button>
											</c:when>
											<c:otherwise>
												<button class="btn btn-secondary w-100" disabled="disabled">Out
													of Stock</button>
											</c:otherwise>
										</c:choose>
									</div>

								</div>
							</div>
						</div>

					</c:forEach>

				</div>
			</div>
		</div>
	</div>

	<div class="modal fade" id="paymentModal" tabindex="-1"
		aria-hidden="true">
		<div class="modal-dialog modal-dialog-centered">
			<div class="modal-content">
				<form action="${pageContext.request.contextPath}/CartServlet"
					method="post">
					<div class="modal-header">
						<h5 class="modal-title">Payment Details</h5>
						<button type="button" class="btn-close" data-bs-dismiss="modal"
							aria-label="Close"></button>
					</div>
					<div class="modal-body">
						<!-- div class="alert alert-info small">Demo payment only. Fill
							the fields below to continue with the purchase.</div-->
						<div class="mb-3">
							<label class="form-label">Selected Book</label>
							<div class="form-control bg-light" id="paymentBookTitle">Book</div>
						</div>
						<input type="hidden" name="action" id="paymentAction"
							value="buyNow"> <input type="hidden" name="bookId"
							id="paymentBookId"> <input type="hidden"
							name="removeIndex" id="paymentRemoveIndex">
						<div class="mb-3">
							<label class="form-label">Card Holder Name</label> <input
								type="text" name="paymentName" class="form-control"
								placeholder="card holder" required>
						</div>
						<div class="mb-3">
							<label class="form-label">Card Number</label> <input type="text"
								name="paymentNumber" class="form-control"
								placeholder="4111 1511 1161 1117" required>
						</div>
						<div class="row g-3">
							<div class="col-md-6 mb-3">
								<label class="form-label">Expiry</label> <input type="text"
									name="paymentExpiry" class="form-control" placeholder="MM/YY"
									required>
							</div>
							<div class="col-md-6 mb-3">
								<label class="form-label">CVV</label> <input type="password"
									name="paymentCvv" class="form-control" placeholder="123"
									required>
							</div>
						</div>
					</div>
					<div class="modal-footer">
						<button type="button" class="btn btn-secondary"
							data-bs-dismiss="modal">Cancel</button>
						<button type="submit" class="btn btn-outline-primary">Continue
							Payment</button>
					</div>
				</form>
			</div>
		</div>
	</div>

	<script>
		const paymentModal = document.getElementById('paymentModal');
		if (paymentModal) {
			paymentModal
					.addEventListener(
							'show.bs.modal',
							function(event) {
								const button = event.relatedTarget;
								if (!button)
									return;

								const action = button
										.getAttribute('data-action')
										|| 'buyNow';
								const bookId = button
										.getAttribute('data-book-id')
										|| '';
								const bookTitle = button
										.getAttribute('data-book-title')
										|| 'Book';
								const removeIndex = button
										.getAttribute('data-remove-index')
										|| '';

								document.getElementById('paymentAction').value = action;
								document.getElementById('paymentBookId').value = bookId;
								document.getElementById('paymentRemoveIndex').value = removeIndex;
								document.getElementById('paymentBookTitle').textContent = bookTitle;
							});
		}
	</script>

</body>
</html>
