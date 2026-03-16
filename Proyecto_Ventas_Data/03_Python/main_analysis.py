import pandas as pd
from sqlalchemy import create_engine
import matplotlib.pyplot as plt
import matplotlib.ticker as mtick # Para formato de moneda

# 1. Conexión a tu base de datos profesional
engine = create_engine("mysql+pymysql://root:@localhost/sales_project")

print("--- 🔌 Conectando a MySQL ---")

# 2. Extraer datos de la tabla sales_data
df = pd.read_sql("SELECT * FROM sales_data", engine)

# 3. Limpieza de Fechas (Normaliza formatos de 1 y 2 dígitos automáticamente)
df['order_date'] = pd.to_datetime(df['order_date'], dayfirst=True)

# 4. Análisis: Rentabilidad por Categoría (Redondeado a 2 decimales)
rentabilidad = df.groupby('category')['profit'].sum().sort_values(ascending=False).round(2)

print("\n--- 📊 REPORTE DE RENTABILIDAD (USD) ---")
print(rentabilidad)

# 5. Generar Entregables
# A. El archivo CSV para Excel
rentabilidad.to_csv("reporte_rentabilidad.csv")
print("\n✅ Reporte generado: 'reporte_rentabilidad.csv'")

# B. La Gráfica Profesional (PNG con formato de moneda)
plt.figure(figsize=(10, 6))
ax = rentabilidad.plot(kind='bar', color=['#27ae60', '#f1c40f', '#e67e22'])

# Formatear el eje Y para que muestre $ y comas (ej. $600,000)
fmt = '${x:,.0f}'
tick = mtick.StrMethodFormatter(fmt)
ax.yaxis.set_major_formatter(tick)

plt.title('Ganancia Total por Categoría (USD)', fontsize=14, fontweight='bold')
plt.ylabel('Ganancia Acumulada', fontsize=12)
plt.xlabel('Categoría', fontsize=12)
plt.xticks(rotation=0) 
plt.grid(axis='y', linestyle='--', alpha=0.3)
plt.tight_layout()

plt.savefig("grafico_rentabilidad.png")
print("🖼️  Imagen profesional generada: 'grafico_rentabilidad.png'")