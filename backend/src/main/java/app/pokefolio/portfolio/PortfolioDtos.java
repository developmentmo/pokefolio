package app.pokefolio.portfolio;

import app.pokefolio.portfolio.HoldingDtos.HoldingDto;
import app.pokefolio.transaction.TransactionDtos.TransactionDto;
import java.math.BigDecimal;
import java.time.Instant;
import java.time.LocalDate;
import java.util.List;

public final class PortfolioDtos {

    private PortfolioDtos() {
    }

    /**
     * @param unrealizedGain      over copies with both a market price and a purchase price (see gainCoverage)
     * @param realizedGain        sum over sales of net proceeds minus cost basis (copies with known cost)
     * @param priceSources        sources of the prices used
     * @param sampleData          true when any price used is sample data (mock provider)
     * @param oldestPriceAt       oldest price observation used, so users can judge freshness
     * @param stalePricedCopies   copies valued with a stale price
     */
    public record PortfolioSummaryDto(String currency, BigDecimal marketValue, BigDecimal costBasis,
            BigDecimal unrealizedGain, BigDecimal unrealizedGainPercent, BigDecimal realizedGain, int distinctCards,
            int copies, int pricedCopies, int unpricedCopies, int copiesWithoutCost, int stalePricedCopies,
            List<String> priceSources, boolean sampleData, Instant oldestPriceAt, Instant latestPriceAt,
            List<String> warnings) {
    }

    public record DashboardDto(PortfolioSummaryDto summary, List<HoldingDto> recentlyAdded,
            List<HoldingDto> mostValuable, List<TransactionDto> recentTransactions) {
    }

    public record HistoryPointDto(LocalDate date, BigDecimal marketValue, BigDecimal costBasis, int copies,
            int unpricedCopies) {
    }

    public record PortfolioHistoryDto(String currency, boolean sampleData, String methodology,
            List<HistoryPointDto> points) {
    }
}
