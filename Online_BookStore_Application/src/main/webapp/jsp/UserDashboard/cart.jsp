<%@ page language="java"%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>

<!DOCTYPE html>
<html>
<head>

<title>Books to Buy</title>

<link
	href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"
	rel="stylesheet">

<link
	href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css"
	rel="stylesheet">
<script
	src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>

<style>
body {
	background: #f5f7fb;
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
	background: #0f172a;
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

.card {
	border: none;
	border-radius: 18px;
}

.book-img {
	width: 60px;
	height: 84px;
	object-fit: cover;
	border-radius: 10px;
	border: 1px solid #dee2e6;
	background: #fff;
}

.cart-thumb {
	width: 60px;
	height: 84px;
	object-fit: cover;
	border-radius: 10px;
	border: 1px solid #dee2e6;
	background: #fff;
}

.cart-thumb-fallback {
	width: 60px;
	height: 84px;
	border-radius: 10px;
	border: 1px solid #dee2e6;
	background: linear-gradient(135deg, #f8f9fa, #e9ecef);
}

.purchased-book-card {
	height: 100%;
	border: none;
	border-radius: 16px;
	overflow: hidden;
}

.purchased-book-cover {
	width: 100%;
	height: 170px;
	object-fit: cover;
	background: #fff;
}

.cart-table td, .cart-table th {
	padding: 0.6rem 0.75rem;
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

<body>
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
						class="bi bi-speedometer2"></i>Dashboard</a> <a
						href="${pageContext.request.contextPath}/books"><i
						class="bi bi-journal-bookmark"></i>Browse Books</a> <a class="active"
						href="${pageContext.request.contextPath}/CartServlet"><i
						class="bi bi-cart3"></i>My Books</a> <a
						href="${pageContext.request.contextPath}/dashboard#accountSection"><i
						class="bi bi-person-lines-fill"></i>Profile</a> <a
						href="${pageContext.request.contextPath}/LogoutServlet"
						onclick="return confirm('Are you sure you want to logout?');"><i
						class="bi bi-box-arrow-right"></i>Logout</a>
				</div>

				<div class="sidebar-footer">
					<!-- div class="small text-white-50 mb-1">Cart items</div>
					<div class="h4 mb-0">${sessionScope.cartCount}</div>
					<hr class="border-light opacity-25 my-3"-->
					<div class="small text-white-50 mt-3 mb-1">Purchased books</div>
					<div class="h5 mb-0">${sessionScope.myBookCount}</div>
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

				<!-- div class="d-flex flex-wrap justify-content-between align-items-center gap-3 mb-4">
                <div>
                    <h2 class="mb-1">Books Ready to Buy</h2>
                    <div class="text-muted">Review the books you selected and complete the dummy payment to buy them.</div>
                </div>
                <div class="d-flex gap-2">
                    <a href="${pageContext.request.contextPath}/CartServlet?clear=1" class="btn btn-outline-danger"
                       onclick="return confirm('');">
                        <i class="bi bi-trash me-1"></i>Continue Shopping
                    </a>
                </div>
            </div-->

				<c:choose>
					<c:when test="${empty sessionScope.cartBooks}">
						<!-- div class="alert alert-info mb-4">Your cart is empty.</div-->
					</c:when>
					<c:otherwise>
						<div class="card shadow-sm border-0">
							<div class="table-responsive">
								<table
									class="table table-hover table-sm align-middle mb-0 cart-table">
									<thead class="table-dark">
										<tr>
											<th style="width: 90px;">Image</th>
											<th>Book</th>
											<th>Author</th>
											<th>Qty</th>
											<th>Price</th>
											<th>Category</th>
											<th class="text-end">Action</th>
										</tr>
									</thead>
									<tbody>
										<c:forEach var="item" items="${sessionScope.cartBooks}"
											varStatus="status">
											<tr>
												<td><c:choose>
														<c:when
															test="${not empty item.imageUrl and (fn:startsWith(item.imageUrl, 'http://') or fn:startsWith(item.imageUrl, 'https://') or fn:startsWith(item.imageUrl, 'data:'))}">
															<img class="book-img" src="${item.imageUrl}"
																alt="${item.title}">
														</c:when>
														<c:when test="${not empty item.imageUrl}">
															<img class="book-img"
																src="${pageContext.request.contextPath}${item.imageUrl}"
																alt="${item.title}">
														</c:when>
														<c:otherwise>
															<div
																class="cart-thumb-fallback d-flex align-items-center justify-content-center text-muted">
																<i class="bi bi-book"></i>
															</div>
														</c:otherwise>
													</c:choose></td>
												<td>
													<div class="fw-semibold">${item.title}</div>
													<div class="small text-muted">ID: ${item.id}</div>
												</td>
												<td>${item.author}</td>
												<td><span class="badge bg-primary">${item.quantity}</span></td>
												<td>&#8377; ${item.price}</td>
												<td>${item.category}</td>
												<td class="text-end">
													<div class="d-flex justify-content-end gap-2 flex-wrap">
														<button type="button" class="btn btn-sm btn-success"
															data-bs-toggle="modal" data-bs-target="#paymentModal"
															data-action="buyCartItem"
															data-remove-index="${status.index}"
															data-book-id="${item.id}" data-book-title="${item.title}">
															<i class="bi bi-bag-check me-1"></i>Buy Now
														</button>

														<a
															href="${pageContext.request.contextPath}/CartServlet?removeIndex=${status.index}"
															class="btn btn-sm btn-outline-danger"
															onclick="return confirm('Remove this item from the cart?');">
															<i class="bi bi-x-circle me-1"></i>Remove
														</a>
													</div>
												</td>
											</tr>
										</c:forEach>
									</tbody>
								</table>
							</div>
						</div>

						<div class="row justify-content-end mt-4">
							<div class="col-md-5 col-lg-4">
								<div class="card shadow-sm border-0">
									<div class="card-body">
										<div class="d-flex justify-content-between mb-2">
											<span>Cart items</span> <strong>${sessionScope.cartCount}</strong>
										</div>
										<div class="d-flex justify-content-between mb-3">
											<span>Estimated total</span>
											<c:set var="cartTotal" value="0" />
											<c:forEach var="item" items="${sessionScope.cartBooks}">
												<c:set var="cartTotal"
													value="${cartTotal + (item.price * item.quantity)}" />
											</c:forEach>
											<strong>&#8377; ${cartTotal}</strong>
										</div>
										<div class="small text-muted mb-3">Buy a single book now
											or complete payment for all selected books in one step.</div>
										<button type="button" class="btn btn-primary w-100 mb-2"
											data-bs-toggle="modal" data-bs-target="#paymentModal"
											data-action="checkout" data-book-title="All Selected Books">
											<i class="bi bi-bag-check me-1"></i>Buy All Items
										</button>
									</div>
								</div>
							</div>
						</div>
					</c:otherwise>
				</c:choose>

				<!--div class="d-flex justify-content-between align-items-center flex-wrap gap-2 mb-3">
					<div>
						<h3 class="mb-1">My Books</h3>
						<div class="text-muted">
						     Books you purchased successfullyappear here.
						</div>
					</div>
					
					<span class="badge bg-success-subtle text-success fs-6 px-3 py-2">${sessionScope.myBookCount}
						owned
					</span>
				</div-->

				<div
					class="d-flex justify-content-between align-items-center flex-wrap gap-3 mb-3">

					<div>
						<h3 class="mb-1">My Books</h3>
						<div class="text-muted">Books you purchased successfully
							appear here.</div>
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
						</a> <span class="badge bg-success-subtle text-success fs-6 px-3 py-2">
							${sessionScope.myBookCount} owned </span>

					</div>

				</div>

				<c:choose>
					<c:when test="${empty sessionScope.myBooks}">
						<div class="alert alert-info mb-0">You have not purchased
							any books yet.</div>
					</c:when>
					<c:otherwise>
						<div class="row g-3">
							<c:forEach var="item" items="${sessionScope.myBooks}">
								<div class="col-sm-6 col-lg-4">
									<div class="card purchased-book-card shadow-sm h-100">
										<c:choose>
											<c:when
												test="${not empty item.imageUrl and (fn:startsWith(item.imageUrl, 'http://') or fn:startsWith(item.imageUrl, 'https://') or fn:startsWith(item.imageUrl, 'data:'))}">
												<img class="purchased-book-cover" src="${item.imageUrl}"
													alt="${item.title}">
											</c:when>
											<c:when test="${not empty item.imageUrl}">
												<img class="purchased-book-cover"
													src="${pageContext.request.contextPath}${item.imageUrl}"
													alt="${item.title}">
											</c:when>
											<c:otherwise>
												<div
													class="purchased-book-cover d-flex align-items-center justify-content-center text-muted bg-light">
													<i class="bi bi-book fs-1"></i>
												</div>
											</c:otherwise>
										</c:choose>

										<div class="card-body d-flex flex-column">
											<h5 class="mb-1">${item.title}</h5>
											<div class="text-muted small mb-2">by ${item.author}</div>
											<div class="small text-muted mb-3">Owned quantity:
												${item.quantity}</div>
											<div
												class="d-flex justify-content-between align-items-center mt-auto">
												<strong class="text-success">&#8377; ${item.price}</strong>
												<span class="badge bg-primary-subtle text-primary">Purchased</span>

												<button type="button" class="btn btn-sm"
													data-bs-toggle="modal" data-bs-target="#paymentModal"
													data-action="buyAgain" data-book-id="${item.id}"
													data-book-title="${item.title}">
													<i class="bi bi-bag-plus me-1"></i>Buy Again
												</button>

												<button type="button" class="btn btn-sm btn-outline-danger">
													<i class=""></i>Remove
												</button>
											</div>
										</div>
									</div>
								</div>
							</c:forEach>
						</div>
					</c:otherwise>
				</c:choose>
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

						<div class="mb-3">
							<label class="form-label">Selected Item</label>
							<div class="form-control bg-light" id="paymentBookTitle">Book</div>
						</div>
						<input type="hidden" name="action" id="paymentAction"
							value="buyCartItem"> <input type="hidden" name="bookId"
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
								placeholder="4111 1511 1161 1171" required>
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
										|| 'buyCartItem';
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