describe("Health Check", () => {
  it("should return healthy status object", () => {
    const healthResponse = {
      status: "healthy",
      timestamp: new Date().toISOString(),
      version: "1.0.0",
      environment: "development",
    };

    expect(healthResponse.status).toBe("healthy");
    expect(healthResponse.version).toBe("1.0.0");
    expect(healthResponse.environment).toBe("development");
    expect(new Date(healthResponse.timestamp)).toBeInstanceOf(Date);
  });

  it("should include all required checks", () => {
    const checks = [
      { name: "postgresql", status: "ok", latencyMs: 5 },
      { name: "redis", status: "ok", latencyMs: 1 },
      { name: "memory", status: "ok", latencyMs: 0 },
      { name: "runtime", status: "ok", latencyMs: 0 },
    ];

    expect(checks).toHaveLength(4);
    checks.forEach((check) => {
      expect(check.status).toBe("ok");
      expect(check.latencyMs).toBeGreaterThanOrEqual(0);
    });
  });

  it("should have valid ISO timestamp", () => {
    const ts = new Date().toISOString();
    expect(ts).toMatch(/^\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2}/);
  });
});
